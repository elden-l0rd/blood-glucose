import 'package:flutter/material.dart';

class UricAcidCardWomen extends StatefulWidget {
  const UricAcidCardWomen({Key? key}) : super(key: key);

  @override
  _UricAcidCardWomenState createState() => _UricAcidCardWomenState();
}

class _UricAcidCardWomenState extends State<UricAcidCardWomen> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
                        padding: EdgeInsets.only(top: 3, right: 8),
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
                        padding: EdgeInsets.only(top: 0, right: 8),
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
    );
  }
}
