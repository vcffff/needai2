import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:needai/src/data/services/services.dart';
import 'package:needai/src/features/courses/presentation/elements/searchFill.dart';
import 'package:needai/src/features/courses/presentation/popUpFilter.dart';
import 'package:needai/src/features/courses/presentation/widget/oneCourse.dart';


class Course extends StatefulWidget {
  const Course({super.key});

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  final searchBarController = TextEditingController();
  List<oneCourse> displayedCourses = [];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    displayedCourses = List.from(originalCourses);
  }

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  void searchCourse(String searchInput) {
    final suggestions =
        originalCourses.where((onecourse) {
          final onecourseTitle = onecourse.title!.toLowerCase();
          final onecourseType = onecourse.type!.toLowerCase();
          final input = searchInput.toLowerCase();
          return onecourseTitle.contains(input) &&
              (selectedCategory == 'All' ||
                  onecourseType.contains(selectedCategory.toLowerCase()));
        }).toList();

    setState(() {
      displayedCourses = suggestions.isEmpty ? originalCourses : suggestions;
    });
  }

  void updateSelectedCategory(String newCategory) {
    setState(() {
      selectedCategory = newCategory;
    });
    searchCourse(searchBarController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          'Course',
          style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
            iconSize: 40,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              searchBar(),
              const SizedBox(height: 12),
              SizedBox(height: 100, child: listView()),
              const SizedBox(height: 12),
              ButtonGroup(onCategorySelected: updateSelectedCategory),
              listViewCourse(),
            ],
          ),
        ),
      ),
    );
  }

  Widget listViewCourse() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: displayedCourses.length,
      itemBuilder: (context, index) {
        return OneCourse(onecourse: displayedCourses[index]);
      },
    );
  }

  Widget listView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: searches.length,
      itemBuilder: (context, index) {
        return SearchFillContainer(searchFill: searches[index]);
      },
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: searchBarController,
        onChanged: searchCourse,
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: const Color.fromRGBO(235, 235, 245, 0.6),
          contentPadding: const EdgeInsets.symmetric(vertical: 2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(CupertinoIcons.search, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(Icons.tune, color: Colors.grey),
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 900,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              'Search Filter',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          CategoryChooser(),
                          SizedBox(height: 20),
                          hoursChoose(),
                          SizedBox(height: 60),
                          buttons(context),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class ButtonGroup extends StatefulWidget {
  final Function(String) onCategorySelected;

  const ButtonGroup({required this.onCategorySelected, super.key});

  @override
  _ButtonGroupState createState() => _ButtonGroupState();
}

class _ButtonGroupState extends State<ButtonGroup> {
  int selectedIndex = 0;

  final List<String> buttons = ["All", "New", "Popular"];
  String selected = 'All';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 13.0),
          child: Text(
            'Choose your course',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            textAlign: TextAlign.left,
          ),
        ),
        Row(
          children: List.generate(buttons.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = index;
                    selected = buttons[index];
                  });
                  widget.onCategorySelected(selected);
                },
                style: ElevatedButton.styleFrom(
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
      ],
    );
  }
}
