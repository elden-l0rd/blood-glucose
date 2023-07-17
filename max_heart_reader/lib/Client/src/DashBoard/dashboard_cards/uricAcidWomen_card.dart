import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';

class UricAcidCardWomen extends StatefulWidget {
  final double uric_women;
  UricAcidCardWomen({required this.uric_women});

  @override
  _UricAcidCardWomenState createState() => _UricAcidCardWomenState();
}

class _UricAcidCardWomenState extends State<UricAcidCardWomen> {
  double get currentUAwomen => widget.uric_women;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Color.fromARGB(235, 255, 227, 89),
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
                          padding: EdgeInsets.only(top: 3, right: 8),
                          child: Text(
                            currentUAwomen.toStringAsFixed(2),
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
                            'mmol/L',
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
                L10n.translation(context)!.uricacidwomen,
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
