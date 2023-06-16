import 'package:flutter/material.dart';
import 'package:max_heart_reader/Client/src/DashBoard/cholesterol_card.dart';
import 'package:max_heart_reader/Client/src/DashBoard/glucose_card.dart';
import 'package:max_heart_reader/Client/src/DashBoard/heartRate_card.dart';
import 'package:max_heart_reader/Client/src/DashBoard/spo2_card.dart';
import 'package:max_heart_reader/Client/src/DashBoard/uricAcidMen_card.dart';
import 'package:max_heart_reader/Client/src/DashBoard/uricAcidWomen_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: (isPortrait)
            ? AppBar(
                // VERTICAL DEVICE ORIENTATION DETECTED!
                backgroundColor: Colors.black,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/trilogy_logo.png',
                      fit: BoxFit.fitHeight,
                      height: MediaQuery.of(context).size.height * .05,
                    )
                  ],
                ))
            : null,
        body: Stack(children: <Widget>[
          content,
        ]));
  }

  Widget get content => Container(
        child: Column(
          children: <Widget>[
            grid,
          ],
        ),
      );

  Widget get grid => Expanded(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 1,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 14, 0, 0),
                    child: Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
                Expanded( // contains all Cards
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: HeartRateCard(),
                                  ),
                                  Expanded(
                                    child: SpO2Card(),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GlucoseCard(),
                                  ),
                                  Expanded(
                                    child: CholesterolCard(),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: UricAcidCardMen(),
                                  ),
                                  Expanded(
                                    child: UricAcidCardWomen(),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GlucoseCard(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
