import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';

class HeartRateCard extends StatefulWidget {
  final int heartRate;
  HeartRateCard({required this.heartRate});
  
  @override
  _HeartRateCardState createState() => _HeartRateCardState();
}

class _HeartRateCardState extends State<HeartRateCard> {
  int get currentheartRate => widget.heartRate;

  @override
  Widget build(BuildContext context) {
    String storeheartRate = currentheartRate.toString();
    return Card(
      elevation: .0,
      color: Color.fromARGB(255, 246, 227, 226),
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
                          padding: EdgeInsets.only(top: 3, right: 8),
                          child: Text(
                            storeheartRate.toString(),
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
                            'bpm',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 18,
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
                L10n.translation(context)!.heartrate,
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
