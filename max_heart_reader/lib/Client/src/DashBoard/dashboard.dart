import 'package:flutter/material.dart';
import 'package:max_heart_reader/Client/src/DashBoard/dashboard_cards/cholesterol_card.dart';
import 'package:max_heart_reader/Client/src/DashBoard/dashboard_cards/glucose_card.dart';
import 'package:max_heart_reader/Client/src/DashBoard/dashboard_cards/heartRate_card.dart';
import 'package:max_heart_reader/Client/src/DashBoard/dashboard_cards/spo2_card.dart';
import 'package:max_heart_reader/Client/src/DashBoard/dashboard_cards/uricAcidMen_card.dart';
import 'package:max_heart_reader/Client/src/DashBoard/dashboard_cards/uricAcidWomen_card.dart';
import 'package:max_heart_reader/Server/device_data.dart';

class Dashboard extends StatefulWidget {
  final DeviceData deviceData;

  const Dashboard({Key? key, required this.deviceData}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    var isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: (isPortrait)
          ? AppBar(
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
              ),
            )
          : null,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Container(
              height: constraints.maxHeight,
              child: Stack(
                children: <Widget>[
                  content,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget get content => Container(
        child: Column(
          children: <Widget>[
            grid,
          ],
        ),
      );

  Widget get grid => Container(
        height: MediaQuery.of(context).size.height * .79,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
              width: double.infinity,
            ),
            Expanded(
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
                                child: Material(
                                  color: Colors.transparent,
                                  child: HeartRateCard(
                                    heartRate: widget.deviceData.heartRate,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  color: Colors.transparent,
                                  child: SpO2Card(
                                    SpO2: widget.deviceData.spo2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Material(
                                  color: Colors.transparent,
                                  child: GlucoseCard(
                                    glucose_level: widget.deviceData.glucose,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  color: Colors.transparent,
                                  child: CholesterolCard(
                                    cholesterol: widget.deviceData.cholesterol,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Material(
                                  color: Colors.transparent,
                                  child: UricAcidCardMen(
                                    uric_men: widget.deviceData.UA_men,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  color: Colors.transparent,
                                  child: UricAcidCardWomen(
                                    uric_women: widget.deviceData.UA_women,
                                  ),
                                ),
                              )
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
      );
}
