import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myeatsapp/home.dart';
import 'package:myeatsapp/search.dart';
import 'package:cupertino_setting_control/cupertino_setting_control.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  int index = 2;
  @override
  Widget build(BuildContext context) {
    final red_green_color_blind_mode_toggle = SettingRow(
        rowData: SettingsYesNoConfig(
            initialValue: true, title: 'Red-Green Color Blind Friendly Mode'),
        config: const SettingsRowConfiguration(showAsSingleSetting: true),
        style: const SettingsRowStyle(
          fontSize: 25.0,
          textColor: CupertinoColors.black,
          contentPadding: 25.0,
        ));

    final List<Widget> widgetList = [
      const SizedBox(height: 30.0),
      red_green_color_blind_mode_toggle,
      const SizedBox(height: 30.0),
    ];

    return new Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(
          color: Colors.tealAccent,
          child: ListView(
              children: widgetList,
              physics: const AlwaysScrollableScrollPhysics())),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int index) {
          setState(() {
            this.index = index;
          });
          switch (index) {
            case 0:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
              break;
            case 1:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
              break;
            case 2:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
              break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.amber[800],
      ),
    );
  }
}
