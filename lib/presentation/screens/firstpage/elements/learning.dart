import 'package:flutter/material.dart';
import 'package:needai/presentation/themes/colors.dart';

class Learningd extends StatefulWidget {
  const Learningd({super.key});

  @override
  State<Learningd> createState() => _LearningdState();
}

class _LearningdState extends State<Learningd> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 8),
                    ),
                  ],
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              CircularProgressIndicator(
                                value: 0.8,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  maincolor,
                                ),
                                strokeWidth: 6.0,
                                backgroundColor: Colors.grey[200],
                              ),
                              SizedBox(width: 100),
                              Text("Physics"),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              text: "40",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              children: [
                                TextSpan(
                                  text: "/48",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 86),
                                child: CircularProgressIndicator(
                                  value: 0.3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    maincolor,
                                  ),
                                  strokeWidth: 6.0,
                                  backgroundColor: Colors.grey[200],
                                ),
                              ),

                              Container(child: Text("Mathematics  ")),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              text: "6",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              children: [
                                TextSpan(
                                  text: "/24",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
