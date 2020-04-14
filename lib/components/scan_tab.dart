import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:sqflite/sqflite.dart';
import 'package:identifia/components/footer.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:identifia/models/student.dart';

class IdentifiaScanTab extends StatefulWidget {
  @override
  _IdentifiaScanTabState createState() => _IdentifiaScanTabState();
}

class _IdentifiaScanTabState extends State<IdentifiaScanTab> {
  String _barcode = '';
  String _college = '';
  Color _color = CupertinoColors.white;

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes, collegeRes = '';
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await BarcodeScanner.scan();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        barcodeScanRes = 'The user did not grant the camera permission!';
      } else {
        barcodeScanRes = 'Unknown error: $e';
      }
    } on FormatException{
      barcodeScanRes = 'null (User returned using the "back"-button before scanning anything. Result)';
    } catch (e) {
      barcodeScanRes = 'Unknown error: $e';
    } 
    print(barcodeScanRes);
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    try {
      String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, "jacobs.db");

      // Check if the database exists
      bool exists = await databaseExists(path);

      if (!exists) {
        // Should happen only the first time you launch your application
        print("Creating new copy from asset");

        // Make sure the parent directory exists
        try {
          await Directory(dirname(path)).create(recursive: true);
        } catch (_) {}

        // Copy from asset
        ByteData data = await rootBundle.load(join("assets", "jacobs.db"));
        List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        // Write and flush the bytes written
        await File(path).writeAsBytes(bytes, flush: true);
      } else {
        print("Opening existing database");
      }
      // open the database
      var db = await openDatabase(path, readOnly: true);
      List<Map<String, dynamic>> queryRes = await db.rawQuery('SELECT college FROM students WHERE barcode = "$barcodeScanRes"');
      if (queryRes.length > 0) {
        collegeRes = Student.fromMapObject(queryRes.first).college;
      } else {
        collegeRes = 'College not found';
      }
    } catch(err) {
      collegeRes = 'College not found';
      print(err);
    }

    Color newColor = getColor(collegeRes);
    setState(() {
      _barcode = barcodeScanRes;
      _college = collegeRes;
      _color = newColor;
    });
  }

  Color getColor(String college) {
    switch(college) {
      case 'Krupp':
      case 'Krupp E':
      case 'Krupp F':
        return CupertinoColors.systemRed;
      case 'Mercator':
        return CupertinoColors.systemBlue;
      case 'C3':
        return CupertinoColors.systemGreen;
      case 'Nordmetall':
        return CupertinoColors.systemYellow;
      default:
        return CupertinoColors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Flexible(
            child: Container(
              color: _color,
              child: Center(
                child: Text(
                  _college,
                  style: TextStyle(fontSize: 70, color: CupertinoColors.white),
                )
              ),
            )
          ),
          Flexible(
            child: Container(
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CupertinoButton.filled(
                    onPressed: () => scanBarcodeNormal(),
                    child: Text("Start Campus Card Scan")
                  ),
                  // Text('Scan result : $_barcode\n', style: TextStyle(fontSize: 20))
                ]
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20, top: 20),
            child: Footer(),
          ),
        ],
      )
    );
  }
}
