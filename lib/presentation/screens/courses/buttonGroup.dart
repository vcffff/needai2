library buttonGroup;

import 'package:flutter/material.dart';

class ButtonGroup extends StatefulWidget {
  @override
  _ButtonGroupState createState() => _ButtonGroupState();
}

class _ButtonGroupState extends State<ButtonGroup> {
  int selectedIndex = 0;
  String selected = '';
  final List<String> buttons = ["All", "New", "Popular"];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            'Choice your course',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: List.generate(buttons.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: FilledButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = index;
                    selected = buttons[selectedIndex];
                  });
                },
                style: FilledButton.styleFrom(
                  backgroundColor:
                      selectedIndex == index ? Colors.blue : Colors.white,
                  foregroundColor:
                      selectedIndex == index ? Colors.white : Colors.black,
                ),
                child: Text(buttons[index]),
              ),
            );
          }),
        ),
        ListView.builder(itemBuilder: (context, index) {}),
      ],
    );
  }
}
