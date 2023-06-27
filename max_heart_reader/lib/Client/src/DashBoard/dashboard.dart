import 'package:flutter/material.dart';
import 'package:max_heart_reader/Client/src/DashBoard/cholesterol_card.dart';
import 'package:max_heart_reader/Client/src/DashBoard/glucose_card.dart';
import 'package:max_heart_reader/Client/src/DashBoard/heartRate_card.dart';
import 'package:max_heart_reader/Client/src/DashBoard/spo2_card.dart';
import 'package:max_heart_reader/Client/src/DashBoard/uricAcidMen_card.dart';
import 'package:max_heart_reader/Client/src/DashBoard/uricAcidWomen_card.dart';
import 'package:max_heart_reader/Server/device_data.dart';

class Dashboard extends StatefulWidget {
  final DeviceData deviceData;
  const Dashboard({Key? key, required this.deviceData}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isExpanded = false;

  get battery => this.battery;
  get heartRate => this.heartRate;
  get spo2 => this.spo2;
  get glucose => this.glucose;
  get cholesterol => this.cholesterol;
  get UA_men => this.UA_men;
  get UA_women => this.UA_women;

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    // setState(() {});

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
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: Container(
                height: constraints.maxHeight,
                child: Stack(children: <Widget>[
                  content,
                ]),
              ),
            );
          },)
        ); 

    // @override
    // Widget build(BuildContext context) {
    //   var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    //
    //   return Container(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         if (isPortrait)
    //           AppBar(
    //             // VERTICAL DEVICE ORIENTATION DETECTED!
    //             backgroundColor: Colors.black,
    //             title: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Image.asset(
    //                   'assets/images/trilogy_logo.png',
    //                   fit: BoxFit.fitHeight,
    //                   height: MediaQuery.of(context).size.height * .05,
    //                 )
    //               ],
    //             ),
    //           ),
    //         Expanded(
    //           child: Stack(
    //             children: <Widget>[
    //               content,
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
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
              // contains all Cards
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
                                child: HeartRateCard(heartRate: widget.deviceData.heartRate),
                              ),
                              Expanded(
                                child: SpO2Card(SpO2: widget.deviceData.spo2),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: GlucoseCard(
                                    glucose_level: widget.deviceData.glucose),
                              ),
                              Expanded(
                                child: CholesterolCard(
                                    cholesterol: widget.deviceData.cholesterol),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: UricAcidCardMen(
                                    uric_men: widget.deviceData.UA_men),
                              ),
                              Expanded(
                                child: UricAcidCardWomen(
                                    uric_women: widget.deviceData.UA_women),
                              )
                            ],
                          ),
                        ),
                        // Expanded(
                        //   child: Row(
                        //     children: [
                        //       Expanded(
                        //         child: GlucoseCard(),
                        //       ),
                        //     ],
                        //   ),
                        // ),
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
