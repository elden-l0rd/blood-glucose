// Flutter
// ignore_for_file: constant_identifier_names, non_constant_identifier_names

// Flutter/Dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// Project Files
import '../globals.dart' as globals;
// import 'ifttt_notifications.dart';
import '../Server/src/find_devices.dart' as findDevicesWidget;

// BLE
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// InfluxDB Upload
import 'package:influxdb_client/api.dart';

// Email/Telegram notifications: IFTTT
// https://www.youtube.com/watch?v=YkA4TUgCmRA&ab_channel=StechiezDIY
// https://ifttt.com/my_applets

// Wakelock
// import 'package:wakelock/wakelock.dart';




void runBackgroundDeviceScan(){

  //debugPrint('runBackgroundDeviceScan: enabling WakeLock...');
  // Doesn't work here...
  //Wakelock.enable();


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
        // processDeviceScanResults(results);
        _scanComplete = true;
        }
      }
  });

  FlutterBluePlus.instance.stopScan();

  globals.isScanning = false;
  debugPrint('runBackgroundDeviceScan: isScanning status: ${globals.isScanning}');
  
}


void processDeviceScanResults(List<ScanResult> results){

  // You can generate an API token from the "API Tokens Tab" in the UI
  var token = "L4xYFrA1qCalWR1gvjoP0578B9k0J9stB36qlsWxSBNleJKrsKEbNuxRS6fWtggGe_-2YFNjFC2ZsWtQSEDyvw==";
  var org = 'rhys@3logytech.com';
  var bucket = 'Max Heart Reader';
  var url = "https://ap-southeast-2-1.aws.cloud2.influxdata.com";

  var influxDBClient = InfluxDBClient(
    url: url,
    token: token,
    org: org,
    bucket: bucket
  );

  List uploadData = [];

  //debugPrint('processDeviceScanResults: results = $results');

  for(int i = 0; i < results.length; i++){
    ScanResult currentDevice = results[i];
    if(currentDevice.device.name.isNotEmpty && currentDevice.advertisementData.connectable && currentDevice.advertisementData.serviceData.isNotEmpty){ // valid BLE device
      // if(currentDevice.device.name.contains("3LOGY-Heart")){ // 3logytech device verification (could be changed to "3LOGY-Watch" etc.)
      if(currentDevice.device.name.contains("BGL")){ // 3logytech device verification (could be changed to "3LOGY-Watch" etc.)
        //debugPrint('processDeviceScanResults: BLE Device Found! results[$i] = $currentDevice');
        String currentDeviceName = currentDevice.device.name;
        String currentDeviceData = getNiceServiceData(currentDevice.advertisementData.serviceData);
        debugPrint('processDeviceScanResults: BLE Device Found! $currentDeviceName = $currentDeviceData');

        Point dataPoint = createInfluxPoint(currentDeviceData, currentDeviceName);
        uploadData.add(dataPoint);
        //debugPrint('processDeviceScanResults: influxdb datapoint added to uploadData successfully!');
      }
    }
          
  }

  if(uploadData.isNotEmpty){
    uploadInflux(uploadData, influxDBClient);
  }

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

Point createInfluxPoint(input, deviceName){

  // [FFFE0B4A0069905F]
  //          ID        Temp        SOS       FALL      Batt      heartrate       SPO2
  //    0x    FFFE      0B4A        0         0         69        90              5F
  //          1         28.90 °C    false     false     99.06 %   144 BPM         95 %

  Point dataPoint = Point("");

  String data = (input.toString()).replaceAll('[', '').replaceAll(']', '');

  if (data.length != 22){
    globals.toastMessage = '[$deviceName]: Data Error! \nIncorrect Data Format!';
    findDevicesWidget.showToast();
    debugPrint('data length: $data.length');
    debugPrint('createInfluxPoint: NON STANDARD LENGTH ERROR! data = $data');
    return dataPoint;
  }

  String IDBytes = data.substring(0, 4); // 0xFFFE
  String batteryBytes = data.substring(4, 6);
  String heartrateBytes = data.substring(6, 8);
  String spo2Bytes = data.substring(8, 10);
  String glucoseBytes = data.substring(12, 14) + data.substring(10, 12);
  String cholesterolBytes = data.substring(16, 18) + data.substring(14, 16);
  String UAmenBytes = data.substring(18, 20);
  String UAwomenBytes = data.substring(20, 22);

  int ID = ((pow(2, 16)).toInt()) - (int.parse(IDBytes, radix: 16)) - 1;                                      // 0xFFFE => 0001 => ID=1
  double battery = double.parse((((int.parse(batteryBytes, radix: 16)) / 106) * 100).toStringAsFixed(2));     // 0x69 => (105/106)*100 => 99.06 %
  int heartRate = int.parse(heartrateBytes, radix: 16);                                                       // 0x90 => 144 BPM
  int spo2 = int.parse(spo2Bytes, radix: 16);                                                                 // 0x5F => 95 %
  double glucose = ((int.parse(glucoseBytes, radix: 16)).toDouble())/100;
  double cholesterol = ((int.parse(cholesterolBytes, radix: 16)).toDouble())/100;
  double UA_men = ((int.parse(UAmenBytes, radix: 16)).toDouble())/100;
  double UA_women = ((int.parse(UAwomenBytes, radix: 16)).toDouble())/100;

  if(data.length == 22){
    dataPoint = Point(deviceName)
    .addTag('Wearable ID', ("Watch"+ID.toString()))
    .addField('Name', deviceName)
    .addField('ID', ID)
    .addField('Battery', battery)
    .addField('Heartrate', heartRate)
    .addField('SPO2', spo2)
    .addField('Glucose', glucose)
    .addField('Cholesterol', cholesterol)
    .addField('Uric Acid Men', UA_men)
    .addField('Uric Acid Women', UA_women)
    .time(DateTime.now().toUtc());

    debugPrint('createInfluxPoint: InfluxDB Point Created! [Name:$deviceName, ID:$ID, Batt:$battery, HR:$heartRate, SPO2:$spo2, Glucose:$glucose, Cholesterol:$cholesterol, Uric Acid Men:$UA_men, Uric Acid Women:$UA_women]');

  }

  // iftttNotifications(deviceName, sosBytes, fallBytes);
  
  return dataPoint;
}

Future<void> uploadInflux(data, influxDBClient) async {

  var writeService = influxDBClient.getWriteService();
  await writeService.write(data).then((value) {
    debugPrint('uploadInflux: InfluxDB Upload Complete! ${DateTime.now()}');
    debugPrint('background_service: -----------------------------------------------------------------------');
    globals.isScanning = false;
    debugPrint('background_service: isScanning status: ${globals.isScanning}');
  }).catchError((exception) {
    debugPrint('uploadInflux: catchError! exception = $exception');
    globals.isScanning = false;
    debugPrint('background_service: isScanning status: ${globals.isScanning}');
  });

}

