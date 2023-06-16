import 'package:flutter/material.dart';

class GlucoseCard extends StatefulWidget {
  @override
  _GlucoseCardState createState() => _GlucoseCardState();
}

class _GlucoseCardState extends State<GlucoseCard> {
  bool isExpanded = false;

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isExpanded ? MediaQuery.of(context).size.height : null,
      child: Card(
        elevation: .0,
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
                        padding: EdgeInsets.only(top: 13.5, left: 8),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(96, 170, 255, 12),
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
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 3, right: 8),
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
                              padding: EdgeInsets.only(top: 0, right: 8),
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
              heightFactor: 4.2,
              widthFactor: 2.2,
              child: Container(
                width: 72,
                height: 37,
                child: Padding(
                  padding: EdgeInsets.all(6.5),
                  child: Material(
                    elevation: 1.61803399,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: toggleExpansion,
                      child: Text(
                        'Expand',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 141, 141, 141),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}