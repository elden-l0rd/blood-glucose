import 'package:flutter/material.dart';

class NormalDashboard extends StatefulWidget {
  final double battery;
  final String heartRateText;
  final String spo2Text;
  final double glucose;
  final double cholesterol;
  final double UA_men;
  final double UA_women;

  NormalDashboard({
    required this.battery,
    required this.heartRateText,
    required this.spo2Text,
    required this.glucose,
    required this.cholesterol,
    required this.UA_men,
    required this.UA_women
    });

  @override
  _NormalDashboardState createState() => _NormalDashboardState();
}

class _NormalDashboardState extends State<NormalDashboard> {
  double get battery => widget.battery;
  String get heartRateText => widget.heartRateText;
  String get spo2Text => widget.spo2Text;
  double get glucose => widget.glucose;
  double get cholesterol => widget.cholesterol;
  double get UA_men => widget.UA_men;
  double get UA_women => widget.UA_women;

  @override
  Widget build(BuildContext context) {
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
    return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start, // horizontally
                crossAxisAlignment: CrossAxisAlignment.start, // vertically
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: tileHeight,
                        child: Card(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                14.0), // Apply border radius to the Card
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _getGradientColors(
                                    battery), // Function to determine gradient colors
                              ),
                            ),
                            child: Center(
                              child: Text(
                                battery.toStringAsFixed(0) + " %",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
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
                    ],
                  ),
                  Column(children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: tileHeight,
                      child: Card(
                        color: darkTileColor,
                        child: Center(
                          child: Text(
                            heartRateText,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Heart \nRate",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ]),
                  Column(children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: tileHeight,
                      child: Card(
                        color: darkTileColor,
                        child: Center(
                          child: Text(
                            spo2Text,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Blood \nOxygen",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ]),
                  Column(children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: tileHeight,
                      child: Card(
                        color: darkTileColor,
                        child: Center(
                          child: Text(
                            glucose.toStringAsFixed(2),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Glucose",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ]),
                  Column(children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: tileHeight,
                      child: Card(
                        color: darkTileColor,
                        child: Center(
                          child: Text(
                            cholesterol.toStringAsFixed(2),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Cholesterol",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ]),
                  Column(children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: tileHeight,
                      child: Card(
                        color: darkTileColor,
                        child: Center(
                          child: Text(
                            UA_men.toStringAsFixed(2),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Men\nUric Acid",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ]),
                  Column(children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: tileHeight,
                      child: Card(
                        color: darkTileColor,
                        child: Center(
                          child: Text(
                            UA_women.toStringAsFixed(2),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Women\nUric Acid",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ]),
                ],
              ),
            );
  }
}