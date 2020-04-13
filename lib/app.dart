import 'package:flutter/cupertino.dart';
import 'components/scan_tab.dart';

class Identifia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: IdentifiaHomePage(),
    );
  }
}

class IdentifiaHomePage extends StatelessWidget {
  // reference to our single class that manages the database
  // final dbHelper = DatabaseHelper.instance;
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Identifia'),        
      ),
      child: IdentifiaScanTab(),
    );
  }
}
