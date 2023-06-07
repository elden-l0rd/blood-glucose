import 'package:flutter/material.dart';
import 'package:max_heart_reader/find_devices.dart';

import 'package:max_heart_reader/details_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildTitle(context),
    );
  }

  Widget _buildTitle(BuildContext context) {
    // get data from db
    return ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Graph"),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 500,
                    padding: EdgeInsets.all(8.0),
                    child: FutureBuilder<List<graphData>>(
                      future: DatabaseHelper.instance.getGraphDataList(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return buildChart(context, snapshot.data!); // Pass the context and data
                        } else if (snapshot.hasError) {
                          print("========!==================!========");
                          print(snapshot.error);
                          print(DatabaseHelper.instance.getGraphDataList());
                          print("========!==================!========");
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Center(
                            child:
                                CircularProgressIndicator(color: Colors.orange),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildChart(BuildContext context, List<graphData> data) {
    return SingleChildScrollView(
      child: Container(
        height: 420,
        child: SfCartesianChart(
          plotAreaBackgroundColor: Colors.black,
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(minimum: 1.0),
          series: <ChartSeries>[
            RangeColumnSeries<graphData, DateTime>(
              dataSource: data,
              color: Colors.blue,
              xValueMapper: (graphData point, _) => DateTime.parse(point.timestamp),
              lowValueMapper: (graphData point, _) => 0,
              highValueMapper: (graphData point, _) => point.glucose_mmolL,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                showZeroValue: true,
                labelAlignment: ChartDataLabelAlignment.auto,
                labelPosition: ChartDataLabelPosition.inside,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
