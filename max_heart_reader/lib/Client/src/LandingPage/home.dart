import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../Server/src/database_helper.dart';
import 'dart:math'; // for Random (marketing video)

const List<String> timeSelectionList = ["All", "Day", "Week", "Month", "Year"];

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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            // View graph
            child: Container(
              height: 700,
              padding: EdgeInsets.all(8.0),
              child: FutureBuilder<List<graphData>>(
                // future: DatabaseHelper.instance.getGraphDataList(filterMonth: '2023-06-01'),
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
          ),
        ],
      ),
    );
  }

  Widget buildChart(List<graphData> data) {
    List<graphData> rowData = [];

    // !!!!!!!  for Trilogy marketing video  !!!!!!!
    // !!!!!!!  COMMENT OUT for actual code  !!!!!!!
    void generateRandomData() {
      DateTime startDate = DateTime(2023, 6, 8);
      Random random = Random();
      List<Duration> durations = [];

      for (int i = 0; i < 8; i++) {
        Duration randomDuration = Duration(days: random.nextInt(30));
        durations.add(randomDuration);
      }
      durations.sort();
      DateTime currentDate = startDate;

      for (int i = 0; i < 8; i++) {
        currentDate = currentDate.add(durations[i]);

        // Ensure the current date does not exceed the end date
        if (currentDate.isAfter(DateTime(2025, 6, 8))) {
          break;
        }

        String timestamp = currentDate.toString();
        String formattedTimestamp = timestamp.split('.')[0];

        graphData data = graphData(
          timestamp: formattedTimestamp,
          batteryText: '38%',
          heartRateText: '77 bpm',
          spo2Text: '98%',
          glucose_mmolL: 2.0 + Random().nextDouble() * 11,
          glucose_mgDL: .01,
          cholesterolText: '2.01 mg/dL',
          UA_menText: 'Normal: 0.32 mmol/L',
          UA_womenText: 'Normal: 0.26 mmol/L',
        );

        rowData.add(data);
      }
      print("Data added successfully!");
    }

    generateRandomData();
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
    //   .
    //   .
    //   .
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

    String dropdownValue = timeSelectionList.first;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 87, 86, 86),
          ),
          child: DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.white),
            dropdownColor: const Color.fromARGB(255, 87, 86, 86),
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
              });
            },
            items:
                timeSelectionList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: SfCartesianChart(
            title: ChartTitle(
              text: "Glucose levels [mmol/L]",
              textStyle: TextStyle(
                fontSize: 15.5,
                color: Colors.white,
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
