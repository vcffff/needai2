import 'package:flutter/material.dart';
import 'package:needai/core/themes/colors.dart';

Widget buttons(context) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: Container(
          height: 80,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              foregroundColor: Colors.blue,

              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Clear'),
          ),
        ),
      ),
      SizedBox(width: 14),
      Expanded(
        flex: 4,
        child: SizedBox(
          height: 80,
          child: FilledButton(
            onPressed: () async {
              showDialog(
                barrierDismissible: false,
                barrierColor: maincolor,
                context: context,
                builder: (_) => Center(child: CircularProgressIndicator()),
              );
              await Future.delayed(Duration(seconds: 2));
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Apply Filters'),
          ),
        ),
      ),
    ],
  );
}

class CategoryChooser extends StatefulWidget {
  const CategoryChooser({super.key});

  @override
  State<CategoryChooser> createState() => _CategoryChooserState();
}

class _CategoryChooserState extends State<CategoryChooser> {
  final List<String> categories = [
    'Design',
    'Pointing',
    'Coding',
    'Music',
    'Visual Identity',
    'Mathematics',
    "Biology",
    "Chemistry",
  ];
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children:
              categories.map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = selected ? category : null;
                    });
                  },
                  selectedColor: Colors.blue.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color:
                        selectedCategory == category
                            ? Colors.blue
                            : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color:
                          selectedCategory == category
                              ? Colors.blue
                              : Colors.grey.shade300,
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}

class hoursChoose extends StatefulWidget {
  const hoursChoose({super.key});

  @override
  State<hoursChoose> createState() => _hoursChooseState();
}

class _hoursChooseState extends State<hoursChoose> {
  final List<String> hours = [
    '3-8 hours',
    '8-12 hours',
    '12-15 hours',
    '15-19 hours',
  ];
  final List<String> selectedHours = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Text(
          'Hours',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 15),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children:
              hours.map((hour) {
                return ChoiceChip(
                  label: Text(hour),
                  selected: selectedHours.contains(hour),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedHours.add(hour);
                      } else {
                        selectedHours.remove(hour);
                      }
                    });
                  },
                  selectedColor: Colors.blue[400],
                  labelStyle: TextStyle(
                    color:
                        selectedHours.contains(hour)
                            ? Colors.white
                            : Colors.black,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
