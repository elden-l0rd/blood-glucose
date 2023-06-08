import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../database_helper.dart';

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
    return Column(
      // View graph
      children: [
        SingleChildScrollView(
          child: Container(
            height: 500,
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
        ),
      ],
    );
  }

  Widget buildChart(List<graphData> data) {

    return Container(
      height: 420,
      child: SfCartesianChart(
        title: ChartTitle(
          text: "Glucose levels [mmol/L]",
          textStyle: TextStyle(
            fontSize: 15.5,
          ),
        ),
        plotAreaBackgroundColor: Colors.black,
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(minimum: 1.0),
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
                fontSize: 10
                ),
            ),
          ),
        ],
      ),
    );
  }
}
