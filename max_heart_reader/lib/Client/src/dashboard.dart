import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
                      height: MediaQuery.of(context).size.height * 0.05,
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
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: GridView.count(
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  children: [
                    Card(
                      //heart rate
                      elevation: .0,
                      color: Color.fromARGB(255, 246, 227, 226),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 13.5, left: 8),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/heart_logo.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 80, width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 3, right: 8),
                                        child: Text(
                                          '88',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 27,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 0, right: 8),
                                        child: Text(
                                          'bpm',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 18),
                            child: Text(
                              'Heart Rate',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      //SpO2
                      elevation: 0.0,
                      color: Color.fromARGB(68, 250, 21, 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 13.5, left: 8),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(44, 253, 27, 11),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/SpO2_icon.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 80, width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 3, right: 8),
                                        child: Text(
                                          '98',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 27,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 0, right: 8),
                                        child: Text(
                                          '%',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 18),
                            child: Text(
                              'SpO2',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 0.0,
                      color: Color.fromARGB(58, 170, 255, 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 13.5, left: 8),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Color.fromARGB(96, 170, 255, 12),
                                        ),
                                        child: ClipOval(
                                          child: Image.asset(
                                            'assets/images/glucose_icon.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 80, width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 3, right: 8),
                                            child: Text(
                                              '4.21',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontSize: 27,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 0, right: 8),
                                            child: Text(
                                              'mmol/L',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 18),
                                child: Text(
                                  'Glucose\nLevel',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Material(
                                elevation: 4,
                                shape: CircleBorder(),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.add),
                                    color: Colors.transparent,
                                    onPressed: () {
                                      // Handle button click
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      //cholesterol level
                      elevation: 0.0,
                      color: Color.fromARGB(54, 4, 238, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 13.5, left: 8),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(87, 88, 236, 247),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/cholesterol_molecule_icon.png',
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 80, width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 3, right: 8),
                                        child: Text(
                                          '2.01',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 27,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 0, right: 8),
                                        child: Text(
                                          'mg/dL',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 18),
                            child: Text(
                              'Cholesterol\nLevel',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      //uric acid (men)
                      elevation: 0.0,
                      color: Color.fromARGB(255, 249, 188, 98),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 13.5, left: 8),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orange,
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/male_icon.png',
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 80, width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 3, right: 8),
                                        child: Text(
                                          '0.47',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 27,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 0, right: 8),
                                        child: Text(
                                          'mmol/L',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 18),
                            child: Text(
                              'Uric Acid\n(Men)',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      //uric acid (women)
                      elevation: 0.0,
                      color: Color.fromARGB(235, 255, 227, 89),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 13.5, left: 8),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(236, 244, 205, 10),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/female_icon.png',
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 80, width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 3, right: 8),
                                        child: Text(
                                          '1.11',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 27,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 0, right: 8),
                                        child: Text(
                                          'mmol/L',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 18),
                            child: Text(
                              'Uric Acid\n(Women)',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
