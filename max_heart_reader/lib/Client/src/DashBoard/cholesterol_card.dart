import 'package:flutter/material.dart';

class CholesterolCard extends StatefulWidget {
  const CholesterolCard({Key? key}) : super(key: key);
  @override
  _CholesterolCardState createState() => _CholesterolCardState();
}

class _CholesterolCardState extends State<CholesterolCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          elevation: .0,
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
                            padding: EdgeInsets.only(top: 3, right: 8),
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
                            padding: EdgeInsets.only(top: 0, right: 8),
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
      ],
    );
  }
}