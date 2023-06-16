import 'package:flutter/material.dart';

class SpO2Card extends StatefulWidget {
  const SpO2Card({Key? key}) : super(key: key);
  @override
  _SpO2CardState createState() => _SpO2CardState();
}

class _SpO2CardState extends State<SpO2Card> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .0,
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
                        padding: EdgeInsets.only(top: 3, right: 8),
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
                        padding: EdgeInsets.only(top: 0, right: 8),
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
    );
  }
}