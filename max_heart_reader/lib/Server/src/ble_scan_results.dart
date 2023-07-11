// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

// 3logytest@gmail.com
// 3logytech123

// Flutter/Dart
import 'package:flutter/material.dart';
import 'package:max_heart_reader/Client/src/DashBoard/dashboard.dart';
import 'package:max_heart_reader/Client/src/DashBoard/normal_dashboard.dart';
import 'dart:async';

// Other project files
import '../../l10n/l10n.dart';
import '../device_data.dart';
import 'database_helper.dart';
import 'export_data.dart';
import 'process_data.dart';

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
        widget.result.advertisementData.serviceData.isNotEmpty &&
        widget.result.device.name.contains("BGL")) {
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
      return Column();
    }
  }

  Future<Widget> _buildTitle(BuildContext context) async {
    if (widget.result.device.name.contains("BGL")) {
      setState(() {});
      // // [FFFE69905F20134041]
      // //    0x    FFFE      69        90              5F          20        13            40              41
      // //          1         99.06 %   144 BPM         95 %
      // //          ID        Batt      heartrate       SPO2        glucose   cholesterol   Men Uric Acid   Women Uric Acid
      List processedData = processData(widget.result.device.name,
          getNiceServiceData(widget.result.advertisementData.serviceData));

      // int ID = processedData[0];
      double battery = processedData[1];
      int heartRate = processedData[2];
      int spo2 = processedData[3];

      // 1.0 mmol/L = 18.02 mg/dL
      double glucose = processedData[4];
      double glucose_mgDL = glucose * 18.02;

      double cholesterol = processedData[5];
      double UA_men = processedData[6]; //in mmol/L
      double UA_women = processedData[7];

      String heartRateText = "";
      String spo2Text = "";
      heartRateText = heartRate.toString();
      String cholesterolText = cholesterol.toStringAsFixed(2);
      spo2Text = spo2.toStringAsFixed(0) + " %";

      String UA_result_M = 'Normal';
      String UA_result_W = 'Normal';

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

      // debugPrint("battery: $battery");
      // debugPrint("heartRate: $heartRate");
      // debugPrint("spo2: $spo2");
      // debugPrint("glucose: $glucose");
      // debugPrint("glucose: $glucose_mgDL");
      // debugPrint("cholesterol: $cholesterol");
      // debugPrint("UA_men: $UA_result_M");
      // debugPrint("UA_women: $UA_result_W");

      // for (graphData row in rowData) {
      //   if (row.glucose_mmolL == 0.0) continue;

      //   try {
      //     int insertedId = await DatabaseHelper.instance.insertGraphData(row);
      //     debugPrint('Data inserted with ID: $insertedId');
      //   } catch (e) {
      //     debugPrint('Error inserting data: $e');
      //   }
      // }

      DeviceData connectedDeviceData = DeviceData(
        battery: int.parse(battery.toStringAsFixed(0)),
        heartRate: heartRate,
        spo2: spo2,
        glucose: glucose,
        cholesterol: cholesterol,
        UA_men: UA_men,
        UA_women: UA_women,
      );

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Dashboard(deviceData: connectedDeviceData),
                    ),
                  );
                },
                icon: Icon(Icons.arrow_forward),
                label: Text(L10n.translation(context).gotodashboard),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, 
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                )
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.result.device.name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
          Text(
            widget.result.device.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          NormalDashboard(
              battery: battery,
              heartRateText: heartRateText,
              spo2Text: spo2Text,
              glucose: glucose,
              cholesterol: cholesterol,
              UA_men: UA_men,
              UA_women: UA_women),
          Row(
            // Export data
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Call method to export as .csv or .xls
                  showExportDialog(context);
                },
                child: Text(L10n.translation(context).exportdata),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
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
}
