import 'package:flutter/material.dart';
import 'package:needai/src/features/main/presentation/elements/footer.dart';
import 'package:needai/src/features/main/presentation/elements/header.dart';
import 'package:needai/src/features/main/presentation/elements/justrow.dart';
import 'package:needai/src/features/main/presentation/elements/learning.dart';
import 'package:needai/src/features/main/presentation/elements/list.dart';
import 'package:needai/src/features/main/presentation/elements/settings_animation.dart' show ProgressAnimation;
import 'package:needai/src/features/main/presentation/elements/white_card.dart';


class Firstpage extends StatefulWidget {
  const Firstpage({super.key});
  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage>
    with SingleTickerProviderStateMixin {
  late ProgressAnimation progressAnimation;
  @override
  void initState() {
    super.initState();
    progressAnimation = ProgressAnimation(
      vsync: this,
      onUpdate: () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    progressAnimation.dispose();
    super.dispose();
  }

  int currentpage = 0;
  void onchanged(int index) {
    setState(() {
      currentpage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              Header(),
              // White Card Section
              WhiteCard(),
              //list of lessons
              Listdart(),
              //just learning page
              Justrow(),
              //progress
              Learningd(),

              //meetup(footerpage)
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
