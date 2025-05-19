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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
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

                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  value: 0.8,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey,
                                  ),
                                  strokeWidth: 6.0,
                                  backgroundColor: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Physics",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF1B1B1D),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "40/48",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  value: 0.25,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey,
                                  ),
                                  strokeWidth: 6.0,
                                  backgroundColor: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Mathematics",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF1B1B1D),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "6/24",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.withOpacity(0.6),
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
