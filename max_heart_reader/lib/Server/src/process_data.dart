// Purpose: Interprets the string of bytes received from the BLE device. An example of the bytes received is as line 1 of the processData().

import 'package:flutter/material.dart';
import '../../utils/globals.dart' as globals;
import 'find_devices.dart' as findDevicesWidget;
import 'dart:math';

String getNiceHexArray(List<int> bytes) {
  return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join('')}]'
      .toUpperCase();
}

String getNiceServiceData(Map<String, List<int>> data) {
  if (data.isEmpty) {
    return 'N/A';
  }

  List<String> res = [];
  data.forEach((id, bytes) {
    res.add(getNiceHexArray(bytes));
  });
  return res.join();
}

List processData(deviceName, data) {
  // [FFFE69905F201213624041]
  //    0x    FFFE      69        90              5F          2012        1362            40              41
  //          1         99.06 %   144 BPM         95 %
  //          ID        Batt      heartrate       SPO2        glucose   cholesterol   Men Uric Acid   Women Uric Acid

  List returnData = [];
  String fullData = (data.toString()).replaceAll('[', '').replaceAll(']', '');

  debugPrint('fulldata = $fullData');
  if (fullData.length != 22) {
    globals.toastMessage = '[$deviceName]: Data Error! \nIncorrect Data Format!';
    findDevicesWidget.showToast();
    debugPrint('ble_scan_results.dart: processData: NON STANDARD LENGTH ERROR! data = $fullData');
    return returnData;
  }

  String IDBytes = fullData.substring(0, 4); // 0xFFFE
  String batteryBytes = fullData.substring(4, 6);
  String heartrateBytes = fullData.substring(6, 8);
  String spo2Bytes = fullData.substring(8, 10);
  String glucoseBytes = fullData.substring(12, 14) + fullData.substring(10, 12);
  String cholesterolBytes = fullData.substring(16, 18) + fullData.substring(14, 16);
  String UAmenBytes = fullData.substring(18, 20);
  String UAwomenBytes = fullData.substring(20, 22);

  int ID = ((pow(2, 16)).toInt()) - (int.parse(IDBytes, radix: 16)) - 1; // 0xFFFE => 0001 => ID=1
  double battery = double.parse((((int.parse(batteryBytes, radix: 16)) / 106) * 100).toStringAsFixed(2)); // 0x69 => (105/106)*100 => 99.06 %
  int heartRate = int.parse(heartrateBytes, radix: 16); // 0x90 => 144 BPM
  int spo2 = int.parse(spo2Bytes, radix: 16); // 0x5F => 95 %
  double glucose = ((int.parse(glucoseBytes, radix: 16)).toDouble()) / 100;
  double cholesterol = ((int.parse(cholesterolBytes, radix: 16)).toDouble()) / 100;
  double UA_men = ((int.parse(UAmenBytes, radix: 16)).toDouble()) / 100;
  double UA_women = ((int.parse(UAwomenBytes, radix: 16)).toDouble()) / 100;

  debugPrint("ID: $ID");
  debugPrint("battery: $battery");
  debugPrint("heartRate: $heartRate");
  debugPrint("spo2: $spo2");
  debugPrint("glucose: $glucose");
  debugPrint("cholesterol: $cholesterol");
  debugPrint("UA_men: $UA_men");
  debugPrint("UA_women: $UA_women");

  returnData.add(ID);
  returnData.add(battery);
  returnData.add(heartRate);
  returnData.add(spo2);
  returnData.add(glucose);
  returnData.add(cholesterol);
  returnData.add(UA_men);
  returnData.add(UA_women);

  return returnData;
}