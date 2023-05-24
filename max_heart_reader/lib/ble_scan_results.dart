// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

// Flutter/Dart

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

class GlucoseMeasurement {
  final DateTime time;
  final double glucoseMgDL;

  GlucoseMeasurement(this.time, this.glucoseMgDL);
}

List<GlucoseMeasurement> filterMeasurementsByMonth(List<GlucoseMeasurement> measurements, int month) {
  return measurements.where((measurement) => measurement.time.month == month).toList();
} /* Retrieve your data for the desired range of the month. Assuming you have a list of GlucoseMeasurement
   * objects, you can filter it based on the selected month
   */

// Create a chart series from the filtered data
charts.Series<GlucoseMeasurement, DateTime> createChartSeries(List<GlucoseMeasurement> measurements) {
  return charts.Series<GlucoseMeasurement, DateTime>(
    id: 'Glucose',
    colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
    domainFn: (GlucoseMeasurement measurement, _) => measurement.time,
    measureFn: (GlucoseMeasurement measurement, _) => measurement.glucoseMgDL,
    data: measurements,
  );
}

// Build chart widget
charts.TimeSeriesChart buildChart(List<GlucoseMeasurement> measurements) {
  return charts.TimeSeriesChart(
    [createChartSeries(measurements)],
    animate: true,
    dateTimeFactory: const charts.LocalDateTimeFactory(),
    primaryMeasureAxis: const charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
  );
}

int selectedMonth = 5; // Assuming May is the default selected month

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
  String formattedDateTime = DateFormat(globals.timeFormat).format(now);
  return formattedDateTime;
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

      // 1.0 mmol/L = 18.02 mg/dL
      double glucose = processedData[4];
      double glucose_mgDL = glucose*18.02;

      double cholesterol = processedData[5];
      double UA_men = processedData[6]; //in mmol/L
      double UA_women = processedData[7];

      String heartRateText = "";
      String spo2Text = "";
      heartRateText = heartRate.toString();
      spo2Text = spo2.toStringAsFixed(0) + " %";

      String UA_result_M = 'Normal';
      String UA_result_W = 'Normal';

      if (UA_men>=0.24 && UA_men<=0.51) {
        UA_result_M = 'Normal: ${UA_men} mmol/L';
      }
      else UA_result_M = 'Abnormal: ${UA_men} mmol/L';
      if (UA_women>=0.16 && UA_women<=0.43) {
        UA_result_W = 'Normal: ${UA_women} mmol/L';
      }
      else UA_result_W = 'Abnormal: ${UA_women} mmol/L';

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

      List<graphData> rowData = [
        graphData(
          timestamp: getCurrentDateTime(),
          batteryText: "${battery.toStringAsFixed(0)} %",
          heartRateText: '${heartRateText} bpm',
          spo2Text: spo2Text,
          glucose_mmolL: glucose,
          glucose_mgDL: glucose_mgDL,
          cholesterolText: '${cholesterolText} mg/dL',
          UA_menText: UA_result_M,
          UA_womenText: UA_result_W,
        ),
      ];

      debugPrint("battery: $battery");
      debugPrint("heartRate: $heartRate");
      debugPrint("spo2: $spo2");
      debugPrint("glucose: $glucose");
      debugPrint("glucose: $glucose_mgDL");
      debugPrint("cholesterol: $cholesterol");
      debugPrint("UA_men: $UA_result_M");
      debugPrint("UA_women: $UA_result_W");

      for (graphData rows in rowData) {
        DatabaseHelper.instance.insertGraphData(rows).then((insertedId) {
          debugPrint('Data inserted with ID: $timestamp');
        });
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
          Text(
            widget.result.device.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Call method to export as .csv or .xls
                  // temporarily hard coded data into database, just query for now
                  showOptionDialog(context);
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
  
  void showOptionDialog(BuildContext context) {
    String email_add = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Export Format'),
          content: Text('Choose the export format.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Handle the first option - Export as CSV
                Navigator.of(context).pop('csv');
              },
              child: Text('Export as CSV'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle the second option - Export as XLS
                Navigator.of(context).pop('xls');
              },
              child: Text('Export as XLS'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle the second option - Export as XLS
                Navigator.of(context).pop('email_csv');
              },
              child: Text('Export to email as CSV'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle the second option - Export as XLS
                Navigator.of(context).pop('email_xls');
              },
              child: Text('Export to email as XLS'),
            ),
          ],
        );
      },
    ).then((selectedOption) {
      if (selectedOption != null) {
        // Handle the selected option here
        if (selectedOption == 'csv') {
          // Export as CSV
          DatabaseHelper.instance.exportDataAsCSV(false, email_add);
        } 
        else if (selectedOption == 'xls') {
          // Export as XLS
          DatabaseHelper.instance.exportDataAsXLS(false, email_add);
        }
        else if (selectedOption == 'email_csv') {
          // Email as CSV
          showDialog(context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Enter your email'),
                content: TextField(
                  onChanged: (value) {
                    email_add = value;
                  },
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Export'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      DatabaseHelper.instance.exportDataAsCSV(true, email_add);
                    },
                  ),
                ],
              );
            },
          );
        }
        else if (selectedOption == "email_xls") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Enter your email'),
                content: TextField(
                  onChanged: (value) {
                    email_add = value;
                  },
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Export'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      DatabaseHelper.instance.exportDataAsXLS(true, email_add);
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    });
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
