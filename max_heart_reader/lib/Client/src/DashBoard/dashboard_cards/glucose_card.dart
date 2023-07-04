import 'package:flutter/material.dart';

class GlucoseCard extends StatefulWidget {
  final double glucose_level;
  GlucoseCard({required this.glucose_level});

  @override
  _GlucoseCardState createState() => _GlucoseCardState();
}

class _GlucoseCardState extends State<GlucoseCard> {
  bool isExpanded = false;
  
  double get currentglucoselevel => widget.glucose_level;

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    String g = '';
    print(g);
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isExpanded
          ? MediaQuery.of(context).size.height
          : MediaQuery.of(context).size.height / 4,
      width: isExpanded
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width / 2,
      child: Card(
        elevation: .0,
        color: Color.fromARGB(246, 200, 241, 160),
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
                            color: Color.fromARGB(159, 170, 255, 12),
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
                                currentglucoselevel.toString(),
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
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
