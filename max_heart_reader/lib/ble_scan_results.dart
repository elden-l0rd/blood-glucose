// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

// Flutter/Dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

// Other project files
import 'database_helper.dart';
import 'globals.dart' as globals;
import 'find_devices.dart' as findDevicesWidget;

// BLE
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// Graphing tools
import 'package:syncfusion_flutter_charts/charts.dart';


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

  // Widget buildChart(List<graphData> data) {
  //     return Container(
  //       height: 420, 
  //       child: SfCartesianChart(
  //         plotAreaBackgroundColor: Colors.black,
  //         // primaryXAxis: DateTimeAxis(
  //         //   name: "Glucose levels",
  //         //   dateFormat: DateFormat('dd/MM'),
  //         // ),
  //         // primaryYAxis: NumericAxis(
  //         //   minimum: 0,
  //         //   maximum: 12,
  //         //   plotBands: <PlotBand>[
  //         //       PlotBand(
  //         //         isVisible: true,
  //         //         start: 5.5,
  //         //         end: 11.1,
  //         //         color: Color.fromARGB(255, 39, 124, 36).withOpacity(0.05),
  //         //       ),
  //         //     ],
  //         // ),
  //         // series: <ChartSeries>[
  //         //   ColumnSeries<graphData, DateTime>(
  //         //     color: Colors.orange,
  //         //     dataSource: data,
  //         //     xAxisName: 'Time',
  //         //     yAxisName: 'Glucose Level',
  //         //     xValueMapper: (graphData point, _) => DateFormat('dd/MM/yyyy HH:mm:ss').parse(point.timestamp),
  //         //     yValueMapper: (graphData point, _) => point.glucose_mmolL,
  //         //     width: 0.8,
  //         //   ),
  //         // ],
  //         primaryXAxis: CategoryAxis(),
  //         series: <ChartSeries>[
  //           RangeColumnSeries<graphData, DateTime>(
  //             dataSource: data,
  //             color: Colors.orange,
  //             xValueMapper: (graphData point, _) => DateFormat('dd/MM/yyyy HH:mm:ss').parse(point.timestamp),
  //             lowValueMapper: (graphData point, _) => point.glucose_mmolL,
  //             highValueMapper: (graphData point, _) => point.glucose_mmolL+1.0,
  //           )
  //         ],
  //     ),
  //   );
  // }

  Widget buildChart(List<graphData> data) {
    // Commented out function to find MAX and MIN for a RangeSeries
    // Group data by date
    // final Map<String, List<graphData>> dataByDate = {};
    // for (final dataPoint in data) {
    //   // final date = dataPoint.timestamp.split(' ')[0];
    //   final date = dataPoint.timestamp.split(' ')[0].split('/')[0] + '/' + dataPoint.timestamp.split(' ')[0].split('/')[1] + '/' + dataPoint.timestamp.split(' ')[0].split('/')[2];
    //
    //   if (dataByDate.containsKey(date)) {
    //     dataByDate[date]!.add(dataPoint);
    //   }
    //   else {
    //     dataByDate[date] = [dataPoint];
    //   }
    // }
    // // Find lowest and highest values for each day
    // final List<graphData> dailyData = [];
    // for (final entry in dataByDate.entries) {
    //   final date = entry.key;
    //   final dataPoints = entry.value;
    //   double lowestValue = double.infinity;
    //   double highestValue = double.negativeInfinity;
    //
    //   // Find lowest and highest values for the day
    //   for (final dataPoint in dataPoints) {
    //     final glucoseValue = dataPoint.glucose_mmolL;
    //     if (glucoseValue < lowestValue) {
    //       lowestValue = glucoseValue;
    //     }
    //     if (glucoseValue > highestValue) {
    //       highestValue = glucoseValue;
    //     }
    //   }
    //
    //   // Create a graphData object with the lowest and highest values for the day
    //   final dayData = graphData(
    //     timestamp: date, // Use the date as the timestamp
    //     batteryText: 'NIL',
    //     heartRateText: 'NIL',
    //     spo2Text: 'NIL',
    //     glucose_mmolL: double.parse(lowestValue.toStringAsFixed(1)), // TO CHANGE!!! Create a new data struct !!
    //     glucose_mgDL: double.parse(highestValue.toStringAsFixed(1)), // TO CHANGE!!!
    //     cholesterolText: 'NIL',
    //     UA_menText: 'NIL',
    //     UA_womenText: 'NIL',
    //   );
    //   dailyData.add(dayData);
    // }

  return Container(
    height: 420,
    child: SfCartesianChart(
      plotAreaBackgroundColor: Colors.black,
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        RangeColumnSeries<graphData, String>(
          dataSource: data,
          color: Colors.orange,
          xValueMapper: (graphData point, _) => point.timestamp,
          lowValueMapper: (graphData point, _) => 0,
          highValueMapper: (graphData point, _) => point.glucose_mmolL,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.auto,
            labelPosition: ChartDataLabelPosition.inside,
            textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}


  //Widget _buildTitle(BuildContext context, influxDBClient) {
  Widget _buildTitle(BuildContext context) {
    // bool isExpanded = false;
    if(widget.result.device.name.contains("BGL")){ // can be changed to e.g. "3LOGY-Watch"

      // // [FFFE69905F20134041]
      // //    0x    FFFE      69        90              5F          20        13            40              41
      // //          1         99.06 %   144 BPM         95 %        
      // //          ID        Batt      heartrate       SPO2        glucose   cholesterol   Men Uric Acid   Women Uric Acid
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
      
      // Store data into local directory
      String timestamp = getCurrentDateTime();
      String cholesterolText = cholesterol.toString();

      List<graphData> rowData = [
        graphData(
          timestamp: getCurrentDateTime(),
          batteryText: "${battery.toStringAsFixed(0)}%",
          heartRateText: '${heartRateText} bpm',
          spo2Text: spo2Text,
          glucose_mmolL: glucose,
          glucose_mgDL: double.parse(glucose_mgDL.toStringAsFixed(2)),
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


      // // Define the start date and time
      // final startDate = DateTime.now();
      // final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
      // // Generate 20 sets of data spanning 4 months
      // List<graphData> rowData = [
      //   graphData(
      //     timestamp: dateFormat.format(startDate),
      //     batteryText: "90%",
      //     heartRateText: '80 bpm',
      //     spo2Text: '98%',
      //     glucose_mmolL: 5.0,
      //     glucose_mgDL: 100.8,
      //     cholesterolText: '180 mg/dL',
      //     UA_menText: 'Normal',
      //     UA_womenText: 'Normal',
      //   ),
      //   graphData(
      //     timestamp: dateFormat.format(startDate),
      //     batteryText: "85%",
      //     heartRateText: '75 bpm',
      //     spo2Text: '97%',
      //     glucose_mmolL: 6.0,
      //     glucose_mgDL: 104.4,
      //     cholesterolText: '175 mg/dL',
      //     UA_menText: 'Normal',
      //     UA_womenText: 'Normal',
      //   ),
      //   graphData(
      //     timestamp: dateFormat.format(startDate.add(Duration(days: 3))),
      //     batteryText: "92%",
      //     heartRateText: '77 bpm',
      //     spo2Text: '99%',
      //     glucose_mmolL: 2.4,
      //     glucose_mgDL: 97.2,
      //     cholesterolText: '185 mg/dL',
      //     UA_menText: 'Normal',
      //     UA_womenText: 'Normal',
      //   ),
      //   graphData(
      //     timestamp: dateFormat.format(startDate.add(Duration(days: 3))),
      //     batteryText: "92%",
      //     heartRateText: '77 bpm',
      //     spo2Text: '99%',
      //     glucose_mmolL: 5.4,
      //     glucose_mgDL: 97.2,
      //     cholesterolText: '185 mg/dL',
      //     UA_menText: 'Normal',
      //     UA_womenText: 'Normal',
      //   ),
      //   graphData(
      //     timestamp: dateFormat.format(startDate.add(Duration(days: 5))),
      //     batteryText: "72%",
      //     heartRateText: '77 bpm',
      //     spo2Text: '99%',
      //     glucose_mmolL: 10.4,
      //     glucose_mgDL: 97.2,
      //     cholesterolText: '185 mg/dL',
      //     UA_menText: 'Normal',
      //     UA_womenText: 'Normal',
      //   ),
      //   // graphData(
      //   //   timestamp: dateFormat.format(startDate.add(Duration(days: Random().nextInt(15)))),
      //   //   batteryText: "52%",
      //   //   heartRateText: '77 bpm',
      //   //   spo2Text: '99%',
      //   //   glucose_mmolL: 11.4,
      //   //   glucose_mgDL: 97.2,
      //   //   cholesterolText: '185 mg/dL',
      //   //   UA_menText: 'Normal',
      //   //   UA_womenText: 'Normal',
      //   // ),
      //   // graphData(
      //   //   timestamp: dateFormat.format(startDate.add(Duration(days: Random().nextInt(15)))),
      //   //   batteryText: "42%",
      //   //   heartRateText: '77 bpm',
      //   //   spo2Text: '99%',
      //   //   glucose_mmolL: 6.6,
      //   //   glucose_mgDL: 97.2,
      //   //   cholesterolText: '185 mg/dL',
      //   //   UA_menText: 'Normal',
      //   //   UA_womenText: 'Normal',
      //   // ),
      //   // graphData(
      //   //   timestamp: dateFormat.format(startDate.add(Duration(days: Random().nextInt(15)))),
      //   //   batteryText: "32%",
      //   //   heartRateText: '77 bpm',
      //   //   spo2Text: '99%',
      //   //   glucose_mmolL: 4.6,
      //   //   glucose_mgDL: 97.2,
      //   //   cholesterolText: '185 mg/dL',
      //   //   UA_menText: 'Normal',
      //   //   UA_womenText: 'Normal',
      //   // ),
      //   // graphData(
      //   //   timestamp: dateFormat.format(startDate.add(Duration(days: Random().nextInt(15)))),
      //   //   batteryText: "22%",
      //   //   heartRateText: '77 bpm',
      //   //   spo2Text: '99%',
      //   //   glucose_mmolL: 9.5,
      //   //   glucose_mgDL: 97.2,
      //   //   cholesterolText: '185 mg/dL',
      //   //   UA_menText: 'Normal',
      //   //   UA_womenText: 'Normal',
      //   // ),
      //   // graphData(
      //   //   timestamp: dateFormat.format(startDate.add(Duration(days: Random().nextInt(15)))),
      //   //   batteryText: "92%",
      //   //   heartRateText: '77 bpm',
      //   //   spo2Text: '99%',
      //   //   glucose_mmolL: 5.0,
      //   //   glucose_mgDL: 97.2,
      //   //   cholesterolText: '185 mg/dL',
      //   //   UA_menText: 'Normal',
      //   //   UA_womenText: 'Normal',
      //   // ),

      // ];
      
      for (graphData rows in rowData) {
        if (rows.glucose_mgDL==0.0) continue;
        DatabaseHelper.instance.insertGraphData(rows).then((insertedId) {
          debugPrint('Data inserted with ID: $timestamp');
        });
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
          return [Colors.grey, Colors.grey]; // Default colors for negative battery level
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // horizontally
              crossAxisAlignment: CrossAxisAlignment.start, // vertically
              children: [
                Column(children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: tileHeight,
                    child: Card(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0), // Apply border radius to the Card
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _getGradientColors(battery), // Function to determine gradient colors
                          ),
                        ),
                        child: Center(
                          child: Text(
                            battery.toStringAsFixed(0) + " %",
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    "Battery",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],),

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
          Row( // Export data
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
                  primary: Colors.orange,
                ),
              ),
            ],
          ),
          Row( // View graph
            children: [
              Expanded(
                child: Container(
                  height: 500,
                  padding: EdgeInsets.all(8.0),
                  child: FutureBuilder<List<graphData>> (
                    future: DatabaseHelper.instance.getGraphDataList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return buildChart(snapshot.data!);
                      }
                      else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      else {
                        return Center(
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(color: Colors.orange),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column();
    }
  }
  
  void showExportDialog(BuildContext context) {
    String email_add = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            title: Text('Export Format',
                        style: TextStyle(color: Colors.white)
                      ),
            content: Text('Choose the export format.',
                          style: TextStyle(color: Colors.white),
                        ),
            backgroundColor: const Color.fromARGB(255, 39, 39, 39),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // Handle the first option - Export as CSV
                  Navigator.of(context).pop('csv');
                },
                child: Text('Export as CSV',
                            style: TextStyle(color: Colors.white,),),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle the second option - Export as XLS
                  Navigator.of(context).pop('xls');
                },
                child: Text('Export as XLS',
                            style: TextStyle(color: Colors.white,),),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle the second option - Export as XLS
                  Navigator.of(context).pop('email_csv');
                },
                child: Text('Export to email as CSV',
                            style: TextStyle(color: Colors.white,),),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle the second option - Export as XLS
                  Navigator.of(context).pop('email_xls');
                },
                child: Text('Export to email as XLS',
                            style: TextStyle(color: Colors.white,),),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
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
                title: Text('Enter your email',
                            style: TextStyle(color: Colors.white),),
                content: TextField(
                  style: TextStyle(color: Colors.white,),
                  onChanged: (value) {
                    email_add = value;
                  },
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel',
                                style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.orange,
                    ),
                  ),
                  TextButton(
                    child: Text('Export',
                                style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.of(context).pop();
                      DatabaseHelper.instance.exportDataAsCSV(true, email_add);
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.orange,
                    ),
                  ),
                ],
                backgroundColor: const Color.fromARGB(255, 39, 39, 39),
              );
            },
          );
        }
        else if (selectedOption == "email_xls") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Enter your email',
                            style: TextStyle(color: Colors.white),),
                content: TextField(
                  style: TextStyle(color: Colors.white,),
                  onChanged: (value) {
                    email_add = value;
                  },
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel',
                                style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.orange,
                    ),
                  ),
                  TextButton(
                    child: Text('Export',
                                style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.of(context).pop();
                      DatabaseHelper.instance.exportDataAsXLS(true, email_add);
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.orange,
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
