import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../Server/src/database_helper.dart';
import 'rowData.dart'; // for Random (marketing video)

const List<String> timeSelectionList = ["All", "Day", "Week", "Month", "Year"];

class ReviewDataPage extends StatefulWidget {
  const ReviewDataPage({
    Key? key,
  }) : super(key: key);

  @override
  ReviewDataPageState createState() => ReviewDataPageState();
}

class ReviewDataPageState extends State<ReviewDataPage> {
  String dropdownValue = timeSelectionList.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
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
              items: timeSelectionList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            // View graph
            child: Container(
              height: 700,
              padding: EdgeInsets.all(8.0),
              child: FutureBuilder<List<graphData>>(
                future: _fetchGraphData(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  nextPeriod();
                },
                child: Text('Next Period'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
              SizedBox(width: 10), // Add some spacing between the buttons
              ElevatedButton(
                onPressed: () {
                  _updateGraphData();
                },
                child: Text('Update Graph Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<List<graphData>> _fetchGraphData({String? filter}) async {
    if (dropdownValue == 'All') {
      return await DatabaseHelper.instance.getGraphDataList();
    } else if (dropdownValue == 'Day') {
      if (filter != null) {
        return await DatabaseHelper.instance
            .getGraphDataList(filterDay: filter);
      }
      DateTime now = DateTime.now();
      String filterDay = DateTime(now.year, now.month, now.day).toString();
      return await DatabaseHelper.instance
          .getGraphDataList(filterDay: filterDay);
    } else if (dropdownValue == 'Week') {
      if (filter != null) {
        return await DatabaseHelper.instance
            .getGraphDataList(filterWeek: filter);
      }
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      String filterWeek = startOfWeek.toString();
      return await DatabaseHelper.instance
          .getGraphDataList(filterWeek: filterWeek);
    } else if (dropdownValue == 'Month') {
      if (filter != null) {
        return await DatabaseHelper.instance
            .getGraphDataList(filterMonth: filter);
      }
      DateTime now = DateTime.now();
      String filterMonth = DateTime(now.year, now.month).toString();
      return await DatabaseHelper.instance
          .getGraphDataList(filterMonth: filterMonth);
    } else if (dropdownValue == 'Year') {
      if (filter != null) {
        return await DatabaseHelper.instance
            .getGraphDataList(filterYear: filter);
      }
      DateTime now = DateTime.now();
      String filterYear = DateTime(now.year).toString();
      return await DatabaseHelper.instance
          .getGraphDataList(filterYear: filterYear);
    }
    return [];
  }

  void _updateGraphData() {
    setState(() {});
  }

  void nextPeriod() {
    if (dropdownValue == 'Day') {
      // Increment the current date by one day
      DateTime currentDate = DateTime.now().add(Duration(days: 1));
      String filterDay =
          DateTime(currentDate.year, currentDate.month, currentDate.day)
              .toString();
      setState(() {
        dropdownValue = 'Day';
        _fetchGraphData(filter: filterDay); // Fetch data for the next day
      });
    } else if (dropdownValue == 'Week') {
      // Increment the current date by one week
      DateTime currentDate = DateTime.now().add(Duration(days: 7));
      DateTime startOfWeek =
          currentDate.subtract(Duration(days: currentDate.weekday - 1));
      String filterWeek = startOfWeek.toString();
      setState(() {
        dropdownValue = 'Week';
        _fetchGraphData(filter: filterWeek); // Fetch data for the next week
      });
    } else if (dropdownValue == 'Month') {
      // Increment the current date by one month
      DateTime currentDate = DateTime.now().add(Duration(days: 30));
      String filterMonth =
          DateTime(currentDate.year, currentDate.month).toString();
      setState(() {
        dropdownValue = 'Month';
        _fetchGraphData(filter: filterMonth); // Fetch data for the next month
      });
    } else if (dropdownValue == 'Year') {
      // Increment the current date by one year
      DateTime currentDate = DateTime.now().add(Duration(days: 365));
      String filterYear = DateTime(currentDate.year).toString();
      setState(() {
        dropdownValue = 'Year';
        _fetchGraphData(filter: filterYear); // Fetch data for the next year
      });
    }
  }

  Widget buildChart(List<graphData> data) {
    // !!!!!!!  for Trilogy marketing video  !!!!!!!
    // !!!!!!!   UNCOMMENT for actual code   !!!!!!!
    // List<graphData> rowData = [];

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
                fontSize: 16,
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
                // color: Colors.blueAccent,
                pointColorMapper: (graphData point, _) {
                  return (point.glucose_mmolL > 6.9)
                      ? Colors.red
                      : Colors.blueAccent;
                },
                xValueMapper: (graphData point, _) => point.timestamp,
                lowValueMapper: (graphData point, _) => 0,
                highValueMapper: (graphData point, _) =>
                    double.parse(point.glucose_mmolL.toStringAsFixed(2)),
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  showZeroValue: false,
                  angle: -90,
                  labelAlignment: ChartDataLabelAlignment.auto,
                  labelPosition: ChartDataLabelPosition.outside,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            tooltipBehavior: TooltipBehavior(
              enable: true,
              format: 'point.high',
              textStyle: TextStyle(color: Colors.white),
              header: 'Value',
              duration: 1500, // ms
            ),
          ),
        ),
      ],
    );
  }
}
