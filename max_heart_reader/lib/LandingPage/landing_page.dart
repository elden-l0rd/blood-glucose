import 'package:flutter/material.dart';
import 'package:max_heart_reader/find_devices.dart';
import 'package:max_heart_reader/LandingPage/home.dart';
import 'package:max_heart_reader/LandingPage/profile.dart';

import 'package:max_heart_reader/details_screen.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home',
      style: optionStyle,
    ),
    DetailsScreen(),
    FindDevicesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _selectedIndex == 0 || _selectedIndex == 1
        ? AppBar(
          backgroundColor: Colors.black,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/trilogy_logo.png',
                fit: BoxFit.fitHeight,
                height: MediaQuery.of(context).size.height * 0.05,
              )
            ],)
          )
          : null,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth_connected),
            label: 'Find Devices',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
