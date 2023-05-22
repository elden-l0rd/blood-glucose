// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

// Flutter/Dart

import 'package:flutter/material.dart';
import 'dart:math';

// Other project files
import 'database_helper.dart';
import 'globals.dart' as globals;
import 'find_devices.dart' as findDevicesWidget;

// BLE
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// import 'package:csv/csv.dart'; // for .csv files
import 'package:path_provider/path_provider.dart'; //for .txt files and dir
import 'dart:io';
import 'package:intl/intl.dart';
// Graphing tools
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sqflite/sqflite.dart';



// List<charts.Series<graphData, DateTime>> _createSeries(List<graphData> glucoseDataList) {
//   return [
//     charts.Series<graphData, DateTime>(
//       id: 'glucoseData',
//       data: glucoseDataList,
//       domainFn: (graphData glucoseDataList, _) => glucoseDataList.timestamp,
//       measureFn: (graphData glucoseDataList, _) => glucoseDataList.glucoseLevel,
//     ),
//   ];
// }

class GlucoseDataPoint {
  final String timestamp;
  final double glucoseLevel;

  GlucoseDataPoint({required this.timestamp, required this.glucoseLevel});
}

class ScanResultTile extends StatefulWidget {
  const ScanResultTile({Key? key, required this.result, this.onTap})
      : super(key: key);

  final ScanResult result;
  final VoidCallback? onTap;

  @override
  State<ScanResultTile> createState() => _ScanResultTileState();
}

class _ScanResultTileState extends State<ScanResultTile> {

  // Get timestamp function
  String getCurrentDateTime() {
  DateTime now = DateTime.now();
  String formattedDateTime = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);
  return formattedDateTime;
  }

  // Get path of folder
  Future<String> get _localPath async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } catch(e) {
      if (e is MissingPlatformDirectoryException) {
        debugPrint("Documents directory error...");
        return 'NULL';
      }
    }
    return "null";
  }

  // Retrieve the file from path found
  Future<File> get _localFile async {
    final path = await _localPath;
    final file = File('$path/data.csv');
    if (!await file.exists()) {
      file.create();
    }
    return file;
  }

  // Database manipulation: add, append
  Future<void> dataStorageExport(String rowData) async {
    final file = await _localFile;
  
    if (!await file.exists()) {  // File DNE, initialise with headers
      await file.create();
      await file.writeAsString('Timestamp, Battery, Heart Rate, Spo2, Glucose, Cholesterol, UA Men, UA Women\n');
      debugPrint("File DNE before. Now created at ${file.path}");
    }
  
    // Append new rows of data
    await file.writeAsString(rowData + "\n", mode: FileMode.append);
    String time = rowData.substring(0, 18);
    debugPrint("Data added -- $time");
  
  }
  
  @override
  Widget build(BuildContext context) {

    if (widget.result.device.name.isNotEmpty && widget.result.advertisementData.connectable && widget.result.advertisementData.serviceData.isNotEmpty) {
      return ListTile(
        title: _buildTitle(context),
      );
    }
    else {
      return Column();
    }
  }

  //Widget _buildTitle(BuildContext context, influxDBClient) {
  Widget _buildTitle(BuildContext context) {
    // if(widget.result.device.name.contains("3LOGY-Heart")){ // can be changed to e.g. "3LOGY-Watch"
    if(widget.result.device.name.contains("BGL")){ // can be changed to e.g. "3LOGY-Watch"

      // [FFFE69905F20134041]
      //    0x    FFFE      69        90              5F          20        13            40              41
      //          1         99.06 %   144 BPM         95 %        
      //          ID        Batt      heartrate       SPO2        glucose   cholesterol   Men Uric Acid   Women Uric Acid

      List processedData = processData(widget.result.device.name, getNiceServiceData(widget.result.advertisementData.serviceData));

      // int ID = processedData[0];
      double battery = processedData[1];
      int heartRate = processedData[2];
      int spo2 = processedData[3];
      double glucose = processedData[4];
      double cholesterol = processedData[5];
      double UA_men = processedData[6];
      double UA_women = processedData[7];

      String heartRateText = "";
      String spo2Text = "";
      heartRateText = heartRate.toString();
      spo2Text = spo2.toStringAsFixed(0) + " %";

      double tileHeight = 50;

      Color darkTileColor = const Color.fromARGB(255, 25, 25, 25);

      Color batteryTileColor = Colors.black;
      if(battery > 50.0){batteryTileColor = Colors.green;}
      else if(battery > 25.0){batteryTileColor = Colors.orange;}
      else if(battery >= 0.0){batteryTileColor = Colors.red;}
      
      // Store data into local directory
      String timestamp = getCurrentDateTime();
        // Convert all to Strings
      String batteryText = battery.toString();
      // String glucoseText = glucose.toString();
      String cholesterolText = cholesterol.toString();
      String UA_menText = UA_men.toString();
      String UA_womenText = UA_women.toString();

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
          Text(
            widget.result.device.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start, // horizontally
            crossAxisAlignment: CrossAxisAlignment.start, // vertically
            children: [
              // Column(children: [
              //   SizedBox(
              //     width: 30,
              //     height: tileHeight,
              //     child: Card(
              //       color: darkTileColor,
              //       child: Center(child: Text(
              //           ID.toString(),
              //           style: const TextStyle(color: Colors.white, fontSize: 12),
              //       ),),
              //     ),
              //   ),
              //   const Text("ID", style: TextStyle(color: Colors.white, fontSize: 12,), textAlign: TextAlign.center,),
              // ]),
              Column(children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: tileHeight,
                  child: Card(
                    color: batteryTileColor,
                      child: Center(child: Text(
                        battery.toStringAsFixed(0) + " %",
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),),
                  ),
                ),
                const Text("Battery", style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center,),
              ]),

              Column(children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: tileHeight,
                  child: Card(
                    color: darkTileColor,
                      child: Center(child: Text(
                        heartRateText,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),),
                  ),
                ),
                const Text("Heart \nRate", style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center,),
              ]),

              Column(children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: tileHeight,
                  child: Card(
                    color: darkTileColor,
                      child: Center(child: Text(
                        spo2Text,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),),
                  ),
                ),
                const Text("Blood \nOxygen", style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center,),
              ]),

              Column(children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: tileHeight,
                  child: Card(
                    color: darkTileColor,
                      child: Center(child: Text(
                        glucose.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),),
                  ),
                ),
                const Text("Glucose", style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center,),
              ]),

              Column(children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: tileHeight,
                  child: Card(
                    color: darkTileColor,
                      child: Center(child: Text(
                        cholesterol.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),),
                  ),
                ),
                const Text("Cholesterol", style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center,),
              ]),

              Column(children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: tileHeight,
                  child: Card(
                    color: darkTileColor,
                      child: Center(child: Text(
                        UA_men.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),),
                  ),
                ),
                const Text("Men\nUric Acid", style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center,),
              ]),

              Column(children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: tileHeight,
                  child: Card(
                    color: darkTileColor,
                      child: Center(child: Text(
                        UA_women.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),),
                  ),
                ),
                const Text("Women\nUric Acid", style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center,),
              ]),

            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => {
                  // Call method to export as .csv or .xls
                  // dataStorageExport(rowData);
                },
                child: Text('Export data'),
              ),
            ],
          ),
        ],
      );
    } else {
      // The BLE device is valid but does not belong to 3logytech organization
      return Column();
    }
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join('')}]'.toUpperCase();
  }


  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {return 'N/A';}
    
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(getNiceHexArray(bytes));
    });
    return res.join();
  }


  List processData(deviceName, data){
    // [FFFE69905F201213624041]
    //    0x    FFFE      69        90              5F          2012        1362            40              41
    //          1         99.06 %   144 BPM         95 %        
    //          ID        Batt      heartrate       SPO2        glucose   cholesterol   Men Uric Acid   Women Uric Acid


    List returnData = [];

    String fullData = (data.toString()).replaceAll('[', '').replaceAll(']', '');

    debugPrint('fulldata = $fullData');
    if (fullData.length != 22){
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


    int ID = ((pow(2, 16)).toInt()) - (int.parse(IDBytes, radix: 16)) - 1;                                      // 0xFFFE => 0001 => ID=1
    double battery = double.parse((((int.parse(batteryBytes, radix: 16)) / 106) * 100).toStringAsFixed(2));     // 0x69 => (105/106)*100 => 99.06 %
    int heartRate = int.parse(heartrateBytes, radix: 16);                                                       // 0x90 => 144 BPM
    int spo2 = int.parse(spo2Bytes, radix: 16);                                                                 // 0x5F => 95 %
    double glucose = ((int.parse(glucoseBytes, radix: 16)).toDouble())/100;
    double cholesterol = ((int.parse(cholesterolBytes, radix: 16)).toDouble())/100;
    double UA_men = ((int.parse(UAmenBytes, radix: 16)).toDouble())/100;
    double UA_women = ((int.parse(UAwomenBytes, radix: 16)).toDouble())/100;

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

}
