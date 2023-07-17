// Flutter
// ignore_for_file: constant_identifier_names, non_constant_identifier_names

// Flutter/Dart
import 'package:flutter/material.dart';
// Project Files
import '../../../globals.dart' as globals;
// BLE
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


void runBackgroundDeviceScan(){
  // isScanning is starting
  var _scanComplete = false;
  globals.isScanning = true;
  debugPrint('runBackgroundDeviceScan: isScanning status: ${globals.isScanning}');

  debugPrint('runBackgroundDeviceScan: scanning...');
  FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: globals.BLE_SCAN_TIMEOUT));

  debugPrint('runBackgroundDeviceScan: listening...');
  FlutterBluePlus.instance.scanResults.listen((results) {
    if (results.isNotEmpty) {
        if (_scanComplete == false){
        _scanComplete = true;
        }
      }
  });

  FlutterBluePlus.instance.stopScan();

  globals.isScanning = false;
  debugPrint('runBackgroundDeviceScan: isScanning status: ${globals.isScanning}');
  
}

String getNiceServiceData(Map<String, List<int>> data) {
  if (data.isEmpty) {return 'N/A';}
  
  List<String> res = [];
  data.forEach((id, bytes) {
    res.add(getNiceHexArray(bytes));
  });
  return res.join();
}

String getNiceHexArray(List<int> bytes) {
  return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join('')}]'.toUpperCase();
}
