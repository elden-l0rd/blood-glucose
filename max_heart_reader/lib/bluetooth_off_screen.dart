import 'package:flutter/material.dart';
import 'dart:io' show Platform, sleep;

// BLE
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


// Turn on Bluetooth setting in iOS: app_settings package
// https://pub.dev/packages/app_settings
import 'package:app_settings/app_settings.dart';



// 1st Screen: Bluetooth Off Status
class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {

    var operatingSystem = Platform.isAndroid;


    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.20,
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        shadowColor: const Color.fromARGB(0, 0, 0, 0),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/trilogy_logo.png',
              fit: BoxFit.fitHeight,
              height: 50,
            ),
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
              child: const Text('Connect To Bluetooth'),
              width: double.infinity,
              alignment: Alignment.center,
            )
          ],
        ),
      ),

      body: (operatingSystem == true)
      ? 
      // Android Phone
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // vertical center
          crossAxisAlignment: CrossAxisAlignment.center, // horizontal center
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Icon(
              Icons.bluetooth_disabled,
              size: MediaQuery.of(context).size.height * 0.20,
              color: Colors.white54,
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline6
                  ?.copyWith(color: Colors.white),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            ElevatedButton(
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text('TURN ON'),
              ),
              onPressed: () => FlutterBluePlus.instance.turnOn(),
            ),
          ],
        ),
      ) 
      :
      // iOS Phone
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // vertical center
          crossAxisAlignment: CrossAxisAlignment.center, // horizontal center
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Icon(
              Icons.bluetooth_disabled,
              size: MediaQuery.of(context).size.height * 0.20,
              color: Colors.white54,
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline6
                  ?.copyWith(color: Colors.white),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            ElevatedButton(
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text('TURN ON BLUETOOTH \nIN SETTINGS', textAlign: TextAlign.center,),
              ),
              onPressed: () {AppSettings.openBluetoothSettings();},
            ),
          ],
        ),
      ),

      
    );
  }
}