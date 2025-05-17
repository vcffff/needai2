import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:needai/presentation/screens/books_/bookList/bookWebPage.dart';
import 'package:url_launcher/url_launcher.dart';

class bookList extends StatefulWidget {
  final String bookType;
  const bookList({super.key, required this.bookType});

  @override
  State<bookList> createState() => _bookListState();
}

class _bookListState extends State<bookList> {
  List<dynamic> books = [];
  List<dynamic> filteredBooks = [];
  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final DocumentReference documentReference = FirebaseFirestore.instance
          .collection('books')
          .doc('OK4Xx3TE6ovk0ODbfNqt');

      final DocumentSnapshot snapshot = await documentReference.get();
      if (snapshot.exists) {
        setState(() {
          books = snapshot.get('books');
        });
        filteredBooks =
            books
                .where((book) => book['type'] == widget.bookType.toString())
                .toList();
        for (var book in filteredBooks) {
          final String title = book['title'];
          final String url = book['url'];
          final String type = book['type'];
        }
        print(filteredBooks);
      } else {
        print("No books found.");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filtered Books")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.75,
          ),
          itemCount: filteredBooks.length,
          itemBuilder: (context, index) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.45,
                minHeight: MediaQuery.of(context).size.width * 0.3,
              ),
              child: InkWell(
                onTap: () async {
                  final Uri bookUri = Uri.parse(filteredBooks[index]['url']);
                  if (await canLaunchUrl(bookUri)) {
                    try {
                      await launchUrl(bookUri);
                    } catch (e) {
                      print(e.toString());
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.book, size: 40, color: Colors.blue),
                      const SizedBox(height: 10),
                      Text(
                        filteredBooks[index]['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        filteredBooks[index]['type'],
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
