import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchFill {
  final String title;
  final String image;
  final Color colour;

  SearchFill({required this.title, required this.image, required this.colour});
}

final List<SearchFill> searches = [
  SearchFill(
    title: "Computer Science",
    image: 'assets/images/Vector-1.png',
    colour: const Color.fromRGBO(206, 236, 254, 1),
  ),
  SearchFill(
    title: "Math",
    image: 'assets/images/Vector.png',
    colour: const Color.fromRGBO(239, 224, 255, 1),
  ),
  SearchFill(
    title: "Biology",
    image: "assets/images/Vector-1.png",
    colour: const Color.fromARGB(255, 68, 134, 70),
  ),
  SearchFill(
    title: "Languages",
    image: 'assets/images/Vector-1.png',
    colour: const Color.fromRGBO(206, 236, 254, 1),
  ),
  SearchFill(
    title: "Physics",
    image: 'assets/images/Vector.png',
    colour: const Color.fromRGBO(239, 224, 255, 1),
  ),
  SearchFill(
    title: "Astronomy",
    image: 'assets/images/Vector-1.png',
    colour: const Color.fromRGBO(239, 224, 255, 1),
  ),
  SearchFill(
    title: "History",
    image: 'assets/images/Vector-1.png',
    colour: const Color.fromRGBO(206, 236, 254, 1),
  ),
];

class SearchFillContainer extends StatelessWidget {
  final SearchFill searchFill;

  const SearchFillContainer({super.key, required this.searchFill});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 200,
        height: 80,
        decoration: BoxDecoration(
          color: searchFill.colour,
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                searchFill.image,
                fit: BoxFit.contain,
                width: 50,
                height: 50,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: Text(
                      searchFill.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
