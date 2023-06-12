import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Server/src/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      // View graph
      child: Container(
        height: 700,
        padding: EdgeInsets.all(8.0),
        child: FutureBuilder<List<graphData>>(
          future: DatabaseHelper.instance.getGraphDataList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return buildChart(snapshot.data!);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
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
    );
  }

  Widget buildChart(List<graphData> data) {
    List<graphData> rowData = [];

    // !!!!!!!  for Trilogy marketing video !!!!!!!
    // !!!!!!!  UNCOMMENT for actual code   !!!!!!!
    // void generateRandomData() {
    //   DateTime startDate = DateTime(2023, 6, 8);
    //   DateTime endDate = DateTime(2025, 6, 8);
    //   Random random = Random();

    //   for (int i = 0; i < 200; i++) {
    //     DateTime randomDate = DateTime(
    //       startDate.year + random.nextInt(endDate.year - startDate.year + 1),
    //       1 + random.nextInt(12),
    //       1 + random.nextInt(31),
    //       random.nextInt(24),
    //       random.nextInt(60),
    //       random.nextInt(60),
    //     );

    //     String timestamp = randomDate.toString();
    //     String formattedTimestamp = timestamp.split('.')[0];

    //     graphData data = graphData(
    //       timestamp: formattedTimestamp,
    //       batteryText: '38%',
    //       heartRateText: '77 bpm',
    //       spo2Text: '98%',
    //       glucose_mmolL: 2.0 + Random().nextDouble() * 11,
    //       glucose_mgDL: .01,
    //       cholesterolText: '2.01 mg/dL',
    //       UA_menText: 'Normal: 0.32 mmol/L',
    //       UA_womenText: 'Normal: 0.26 mmol/L',
    //     );

    //     rowData.add(data);
    //   }
    //   print("Data added successfully!");
    // }

    // generateRandomData();
    // rowData = [
    //   graphData(
    //     timestamp: '2023-06-08 12:00:00',
    //     batteryText: '38%',
    //     heartRateText: '77 bpm',
    //     spo2Text: '98%',
    //     glucose_mmolL: 2.0 + Random().nextDouble() * 11,
    //     glucose_mgDL: .01,
    //     cholesterolText: '2.01 mg/dL',
    //     UA_menText: 'Normal: 0.32 mmol/L',
    //     UA_womenText: 'Normal: 0.26 mmol/L',
    //   ),
    //   graphData(
    //     timestamp: '2023-06-10 12:00:00',
    //     batteryText: '38%',
    //     heartRateText: '77 bpm',
    //     spo2Text: '98%',
    //     glucose_mmolL: 2.0 + Random().nextDouble() * 11,
    //     glucose_mgDL: .01,
    //     cholesterolText: '2.01 mg/dL',
    //     UA_menText: 'Normal: 0.32 mmol/L',
    //     UA_womenText: 'Normal: 0.26 mmol/L',
    //   ),
    //   graphData(
    //     timestamp: '2023-06-11 12:00:00',
    //     batteryText: '38%',
    //     heartRateText: '77 bpm',
    //     spo2Text: '98%',
    //     glucose_mmolL: 2.0 + Random().nextDouble() * 11,
    //     glucose_mgDL: .01,
    //     cholesterolText: '2.01 mg/dL',
    //     UA_menText: 'Normal: 0.32 mmol/L',
    //     UA_womenText: 'Normal: 0.26 mmol/L',
    //   ),
    //   graphData(
    //     timestamp: '2023-06-11 18:00:00',
    //     batteryText: '38%',
    //     heartRateText: '77 bpm',
    //     spo2Text: '98%',
    //     glucose_mmolL: 2.0 + Random().nextDouble() * 11,
    //     glucose_mgDL: .01,
    //     cholesterolText: '2.01 mg/dL',
    //     UA_menText: 'Normal: 0.32 mmol/L',
    //     UA_womenText: 'Normal: 0.26 mmol/L',
    //   ),
    // ];

    // insert data into db
    for (graphData row in rowData) {
      if (row.glucose_mmolL == 0.0) continue;

      try {
        Future<int> insertedId = DatabaseHelper.instance.insertGraphData(row);
        debugPrint('Data inserted with ID: $insertedId');
      } catch (e) {
        debugPrint('Error inserting data: $e');
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: SfCartesianChart(
            title: ChartTitle(
              text: "Glucose levels [mmol/L]",
              textStyle: TextStyle(
                fontSize: 15.5,
              ),
            ),
            plotAreaBackgroundColor: Colors.black,
            primaryXAxis: CategoryAxis(
              majorGridLines: MajorGridLines(width: 0),
              labelRotation: -84,
            ),
            primaryYAxis: NumericAxis(
              minimum: 1.0,
              zoomFactor: 1.0,
            ),
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
              enablePinching: true,
            ),
            series: <ChartSeries>[
              RangeColumnSeries<graphData, String>(
                dataSource: data,
                color: Colors.blueAccent,
                xValueMapper: (graphData point, _) => point.timestamp,
                lowValueMapper: (graphData point, _) => 0,
                highValueMapper: (graphData point, _) => point.glucose_mmolL,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  showZeroValue: false,
                  angle: -90,
                  labelAlignment: ChartDataLabelAlignment.auto,
                  labelPosition: ChartDataLabelPosition.inside,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
