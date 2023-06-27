import 'package:flutter/material.dart';
import 'package:max_heart_reader/Client/src/LandingPage/home.dart';
import 'package:max_heart_reader/Client/src/DashBoard/dashboard.dart';
import 'package:max_heart_reader/Server/device_data.dart';
import 'package:max_heart_reader/Server/src/find_devices.dart';

import 'package:max_heart_reader/Client/src/details_screen.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  
    DeviceData initData = DeviceData(
    battery: 0,
    heartRate: 0,
    spo2: 0,
    glucose: 0.0,
    cholesterol: 0.0,
    UA_men: 0.0,
    UA_women: 0.0,
    );
  static List<Widget> _widgetOptions = <Widget>[];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _widgetOptions = [
      HomePage(),
      DetailsScreen(),
      FindDevicesScreen(),
      Dashboard(deviceData: initData),
    ];

    return Scaffold(
      appBar: _selectedIndex == 0
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
                ],
              ))
          : null,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth_connected, color: Colors.black),
            label: 'Find Devices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, color: Colors.black),
            label: 'Dashboard',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
