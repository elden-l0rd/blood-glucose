import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';

class SpO2Card extends StatefulWidget {
  final int SpO2;
  SpO2Card({required this.SpO2});

  @override
  _SpO2CardState createState() => _SpO2CardState();
}

class _SpO2CardState extends State<SpO2Card> {
  int get currentspo2 => widget.SpO2;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .0,
      color: Color.fromARGB(255, 255, 113, 146),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 4,
        width: MediaQuery.of(context).size.width / 2,
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
                            currentspo2.toString(),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 30,
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
                                fontSize: 18,
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
                L10n.translation(context)!.spo2,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
