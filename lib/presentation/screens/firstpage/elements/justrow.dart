import 'package:flutter/material.dart';

class Justrow extends StatelessWidget {
  const Justrow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Learning Plan',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
  }
}