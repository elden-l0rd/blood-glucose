// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

// Flutter/Dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

// Other project files
import 'database_helper.dart';
import '../../globals.dart' as globals;
import 'find_devices.dart' as findDevicesWidget;

// BLE
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

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
    String now = DateTime.now().toString();
    String date = now.substring(0, now.indexOf('.')); // removes milliseconds
    return date;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.result.device.name.isNotEmpty &&
        widget.result.advertisementData.connectable &&
        widget.result.advertisementData.serviceData.isNotEmpty) {
      return FutureBuilder<Widget>(
        future: _buildTitle(context),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return ListTile(
              title: snapshot.data,
            );
          } else {
            return CircularProgressIndicator(); // or any other loading indicator
          }
        },
      );
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text("No devices found..")]);
    }
  }

  Widget buildDashboardTile(
      {required String title, required String value,List<Color>? gradientColors, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        gradient: gradientColors != null
            ? LinearGradient(colors: gradientColors)
            : null,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<Widget> _buildTitle(BuildContext context) async {
    double batteryLevel = -.1;
    String batteryText = "- %";
    String heartRateText = "-";
    String spo2Text = "-";
    String glucoseText = "-";
    String cholesterolText = '-';
    String UA_result_M = '-';
    String UA_result_W = '-';

    // device name can be changed
    if (widget.result.device.name.contains("BGL")) {
      // // [FFFE69905F20134041]
      // //    0x    FFFE      69        90              5F          20        13            40              41
      // //          1         99.06 %   144 BPM         95 %
      // //          ID        Batt      heartrate       SPO2        glucose   cholesterol   Men Uric Acid   Women Uric Acid
      List processedData = processData(widget.result.device.name,
          getNiceServiceData(widget.result.advertisementData.serviceData));

      // int ID = processedData[0];
      double battery = processedData[1];
      batteryLevel = battery;
      int heartRate = processedData[2];
      int spo2 = processedData[3];

      // 1.0 mmol/L = 18.02 mg/dL
      double glucose = processedData[4];
      double glucose_mgDL = glucose * 18.02;

      double cholesterol = processedData[5];
      double UA_men = processedData[6]; //in mmol/L
      double UA_women = processedData[7];

      batteryText = batteryLevel.toStringAsFixed(0) + " %";
      heartRateText = heartRate.toString();
      spo2Text = spo2.toStringAsFixed(0) + " %";
      glucoseText = glucose_mgDL.toStringAsFixed(2);
      cholesterolText = cholesterol.toStringAsFixed(2);
      UA_result_M = UA_men.toStringAsFixed(2);
      UA_result_W = UA_women.toStringAsFixed(2);

      if (UA_men >= 0.24 && UA_men <= 0.51) {
        UA_result_M = 'Normal: ${UA_men} mmol/L';
      } else
        UA_result_M = 'Abnormal: ${UA_men} mmol/L';
      if (UA_women >= 0.16 && UA_women <= 0.43) {
        UA_result_W = 'Normal: ${UA_women} mmol/L';
      } else
        UA_result_W = 'Abnormal: ${UA_women} mmol/L';

      // UNCOMMENT FOR ACTUAL APP RELEASE
      // stores data into db
      // List<graphData> rowData = [
      //   graphData(
      //     timestamp: getCurrentDateTime(),
      //     batteryText: "${battery.toStringAsFixed(0)}%",
      //     heartRateText: '${heartRateText} bpm',
      //     spo2Text: spo2Text,
      //     glucose_mmolL: glucose,
      //     glucose_mgDL: double.parse(glucose_mgDL.toStringAsFixed(2)),
      //     cholesterolText: '${cholesterolText} mg/dL',
      //     UA_menText: UA_result_M,
      //     UA_womenText: UA_result_W,
      //   ),
      // ];
      //
      // debugPrint("battery: $battery");
      // debugPrint("heartRate: $heartRate");
      // debugPrint("spo2: $spo2");
      // debugPrint("glucose: $glucose");
      // debugPrint("glucose: $glucose_mgDL");
      // debugPrint("cholesterol: $cholesterol");
      // debugPrint("UA_men: $UA_result_M");
      // debugPrint("UA_women: $UA_result_W");
      //
      // for (graphData row in rowData) {
      //   if (row.glucose_mmolL == 0.0) continue;
      //
      //   try {
      //     int insertedId = await DatabaseHelper.instance.insertGraphData(row);
      //     debugPrint('Data inserted with ID: $insertedId');
      //   } catch (e) {
      //     debugPrint('Error inserting data: $e');
      //   }
      // }
    }

    double tileHeight = 50;
    Color darkTileColor = const Color.fromARGB(255, 25, 25, 25);

    List<Color> _getGradientColors(double battery) {
      if (battery > 50.0) {
        return [Colors.green, Colors.lightGreen];
      } else if (battery > 25.0) {
        return [Colors.orange, Colors.deepOrange];
      } else if (battery >= 0.0) {
        return [Colors.red, Colors.redAccent];
      } else {
        return [
          Colors.grey,
          Colors.grey
        ]; // Default colors for negative battery level
      }
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
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(16),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              buildDashboardTile(
                title: 'Battery',
                value: batteryText,
                gradientColors: _getGradientColors(batteryLevel),
                color: Colors.grey,
              ),
              buildDashboardTile(
                title: 'Heart Rate',
                value: heartRateText,
                color: darkTileColor,
              ),
              buildDashboardTile(
                title: 'Blood Oxygen',
                value: spo2Text,
                color: darkTileColor,
              ),
              buildDashboardTile(
                title: 'Glucose',
                value: glucoseText,
                color: darkTileColor,
              ),
              buildDashboardTile(
                title: 'Cholesterol',
                value: cholesterolText,
                color: darkTileColor,
              ),
              buildDashboardTile(
                title: 'Men Uric Acid',
                value: UA_result_M,
                color: darkTileColor,
              ),
              buildDashboardTile(
                title: 'Women Uric Acid',
                value: UA_result_W,
                color: darkTileColor,
              ),
            ],
          ),
        ),
        Row(
          // Export data
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                // Call method to export as .csv or .xls
                // temporarily hard coded data into database, just query for now
                showExportDialog(context);
              },
              child: Text('Export data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void showExportDialog(BuildContext context) {
    String email_add = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            title: Text('Export Format', style: TextStyle(color: Colors.white)),
            content: Text(
              'Choose the export format.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 39, 39, 39),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // Handle the first option - Export as CSV
                  Navigator.of(context).pop('csv');
                },
                child: Text(
                  'Export as CSV',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle the second option - Export as XLS
                  Navigator.of(context).pop('xls');
                },
                child: Text(
                  'Export as XLS',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle the second option - Export as XLS
                  Navigator.of(context).pop('email_csv');
                },
                child: Text(
                  'Export to email as CSV',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle the second option - Export as XLS
                  Navigator.of(context).pop('email_xls');
                },
                child: Text(
                  'Export to email as XLS',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
            ],
          ),
        );
      },
    ).then((selectedOption) {
      if (selectedOption != null) {
        // Handle the selected option here
        if (selectedOption == 'csv') {
          // Export as CSV
          DatabaseHelper.instance.exportDataAsCSV(false, email_add);
        } else if (selectedOption == 'xls') {
          // Export as XLS
          DatabaseHelper.instance.exportDataAsXLS(false, email_add);
        } else if (selectedOption == 'email_csv') {
          // Email as CSV
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Enter your email',
                  style: TextStyle(color: Colors.white),
                ),
                content: TextField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (value) {
                    email_add = value;
                  },
                ),
                actions: [
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'Export',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      DatabaseHelper.instance.exportDataAsCSV(true, email_add);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
                backgroundColor: const Color.fromARGB(255, 39, 39, 39),
              );
            },
          );
        } else if (selectedOption == "email_xls") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Enter your email',
                  style: TextStyle(color: Colors.white),
                ),
                content: TextField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (value) {
                    email_add = value;
                  },
                ),
                actions: [
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'Export',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      DatabaseHelper.instance.exportDataAsXLS(true, email_add);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
                backgroundColor: const Color.fromARGB(255, 39, 39, 39),
              );
            },
          );
        }
      }
    });
  }

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
      globals.toastMessage =
          '[$deviceName]: Data Error! \nIncorrect Data Format!';
      findDevicesWidget.showToast();
      debugPrint(
          'ble_scan_results.dart: processData: NON STANDARD LENGTH ERROR! data = $fullData');
      return returnData;
    }

    String IDBytes = fullData.substring(0, 4); // 0xFFFE
    String batteryBytes = fullData.substring(4, 6);
    String heartrateBytes = fullData.substring(6, 8);
    String spo2Bytes = fullData.substring(8, 10);
    String glucoseBytes =
        fullData.substring(12, 14) + fullData.substring(10, 12);
    String cholesterolBytes =
        fullData.substring(16, 18) + fullData.substring(14, 16);
    String UAmenBytes = fullData.substring(18, 20);
    String UAwomenBytes = fullData.substring(20, 22);

    int ID = ((pow(2, 16)).toInt()) -
        (int.parse(IDBytes, radix: 16)) -
        1; // 0xFFFE => 0001 => ID=1
    double battery = double.parse(
        (((int.parse(batteryBytes, radix: 16)) / 106) * 100)
            .toStringAsFixed(2)); // 0x69 => (105/106)*100 => 99.06 %
    int heartRate = int.parse(heartrateBytes, radix: 16); // 0x90 => 144 BPM
    int spo2 = int.parse(spo2Bytes, radix: 16); // 0x5F => 95 %
    double glucose = ((int.parse(glucoseBytes, radix: 16)).toDouble()) / 100;
    double cholesterol =
        ((int.parse(cholesterolBytes, radix: 16)).toDouble()) / 100;
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
}