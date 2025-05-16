import 'package:flutter/material.dart';
import 'package:needai/presentation/screens/firstpage/elements/footer.dart';
import 'package:needai/presentation/screens/firstpage/elements/header.dart';
import 'package:needai/presentation/screens/firstpage/elements/justrow.dart';
import 'package:needai/presentation/screens/firstpage/elements/learning.dart';
import 'package:needai/presentation/screens/firstpage/elements/list.dart';
import 'package:needai/presentation/screens/firstpage/elements/settings_animation.dart';
import 'package:needai/presentation/screens/firstpage/elements/white_card.dart'
    show WhiteCard;

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
              //progress
              Learningd(),
              //just learning page
              Justrow(),
              //meetup(footerpage)
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
