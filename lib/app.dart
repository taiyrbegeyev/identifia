import 'package:flutter/cupertino.dart';
import 'tabs/scan_tab.dart';

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
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.photo_camera),
            title: Text('Scan'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            title: Text('Search'),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch(index) {
          case 0:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(
                  child: IdentifiaScanTab(),
                );
              },
            );
          case 1:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(
                  child: Center(
                    child: Text('Hello'),
                  )
                );
              },
            );
        }
      },
    );
  }
}
