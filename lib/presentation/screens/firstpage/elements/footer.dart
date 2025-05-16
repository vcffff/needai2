import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatefulWidget {
  const   Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 20,
            top: 10,
            child: Container(
              child: Image.asset(
                'assets/images/Group 143.png',
                width: 150,
                height: 150,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  'Meetup',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[900],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Off-line exchange of learning experience',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.purple[900],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
