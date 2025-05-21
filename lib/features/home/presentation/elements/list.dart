import 'package:flutter/material.dart';
import 'package:needai/core/constants.dart';
import 'package:needai/core/themes/colors.dart';


class Listdart extends StatefulWidget {
  const Listdart({super.key});

  @override
  State<Listdart> createState() => _ListdartState();
}

class _ListdartState extends State<Listdart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22),
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 15),
            width: 290,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.deepPurple,
                        ),
                        strokeWidth: 6,
                        backgroundColor: lighttext,
                      ),
                    );
                  },
                );
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.pop(context);
                });
              },
              child: Stack(
                children: [
                  Container(
                    height: 180,
                    width: 290,
                    decoration: BoxDecoration(
                      color: boxcolor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  Positioned(
                    right: 0,
                    top: 10,
                    child: Image.asset(
                      images[index],
                      height: 160,
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(19),
                    child: Text(
                      words[index],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
