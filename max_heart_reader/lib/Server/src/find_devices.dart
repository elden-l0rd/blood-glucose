// Flutter
// ignore_for_file: constant_identifier_names

// Purpose: Handles the BLE scanning.

// Flutter/Dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async'; // required to run a timer
// Project files
import '../../l10n/l10n.dart';
import 'ble_scan_results.dart';
import '../../utils/globals.dart' as globals;
// BLE
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// Flutter Toast notification
// https://pub.dev/packages/fluttertoast
import 'package:fluttertoast/fluttertoast.dart';


void showToast() => Fluttertoast.showToast(
    msg: globals.toastMessage,
    fontSize: 16,
    backgroundColor: const Color.fromARGB(220, 158, 158, 158));

// 2nd Screen: Bluetooth On, Connect Device widget
class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  String serviceStatusText = 'ACTIVE';
  Color serviceStatusColor = Colors.green;
  String serviceButtonText = 'STOP \nSERVICE';
  Color serviceButtonColor = Colors.orange[200]!;
  IconData serviceButtonIcon = Icons.stop_circle;

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    // This timer must run and initiate the first scan to get user's permission to access location
    Timer(
      const Duration(seconds: 2),
      () {
        debugPrint('find_devices: one-timer initialization timer activated! getting users permissions...');
        FlutterBluePlus.instance.startScan(timeout: const Duration(milliseconds: 500));
      },
    );

    Timer.periodic(const Duration(seconds: globals.BLE_SCAN_INTERVAL),
        (Timer t) {
      debugPrint('find_devices.dart: Period Timer! isScanning status: ${globals.isScanning}');
      while (globals.isScanning == true) {
        debugPrint('find_devices.dart: another scan is in progress!!! waiting...');
        sleep(const Duration(seconds: 1));
      }

      debugPrint('find_devices: timer activated! running device scan... ${DateTime.now()}');
      FlutterBluePlus.instance
          .startScan(timeout: const Duration(milliseconds: 500));
    });

    return Scaffold(
      // Background color of the whole body of the widget below the AppBar
      backgroundColor: Colors.black,
      appBar: (isPortrait)
          ? AppBar(
              // VERTICAL DEVICE ORIENTATION DETECTED!
              toolbarHeight: MediaQuery.of(context).size.height * 0.15,
              backgroundColor: Colors.black, // color of the AppBar
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/trilogy_logo.png',
                    fit: BoxFit.fitHeight,
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Container(
                    //padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                    child: Text(L10n.translation(context)!.listofdevices,
                        style: TextStyle(fontSize: 16)),
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                ],
              ),
            )
          : AppBar(
              // HORIZONTAL DEVICE ORIENTATION DETECTED!
              toolbarHeight: MediaQuery.of(context).size.height * 0.25,
              backgroundColor: Colors.black, // color of the AppBar
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/trilogy_logo.png',
                    fit: BoxFit.fitHeight,
                    height: MediaQuery.of(context).size.height * 0.10,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Container(
                    child: Text(L10n.translation(context)!.listofdevices,
                        style: TextStyle(fontSize: 16)),
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),

      body: RefreshIndicator(
        onRefresh: () => FlutterBluePlus.instance.startScan(
            timeout: const Duration(seconds: globals.BLE_SCAN_TIMEOUT)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBluePlus.instance.scanResults,
                initialData: const [],
                builder: (c, snapshot) {
                  final scanResults = snapshot.data!;
                  // scanResults.forEach((result) {
                  //   if (result.device.name.isNotEmpty) {
                  //     print('Detected Device (1): ${result.device.name}');
                  //   }
                  // });
                  return Column(
                    children: scanResults
                        .map(
                          (r) => ScanResultTile(
                            result: r,
                            onTap: () => {},
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBluePlus.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton.extended(
              icon: const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2)),
              label: Text(L10n.translation(context)!.stop),
              backgroundColor: Colors.orange[200],
              onPressed: () => FlutterBluePlus.instance.stopScan(),
            );
          } else {
            return FloatingActionButton.extended(
                icon: const SizedBox(
                    height: 20,
                    width: 20,
                    child: Icon(Icons.search, color: Colors.white)),
                label: Text(L10n.translation(context)!.scan),
                backgroundColor: Colors.orange,
                onPressed: () => FlutterBluePlus.instance.startScan(
                    timeout:
                        const Duration(seconds: globals.BLE_SCAN_TIMEOUT)));
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
