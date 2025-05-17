import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:needai/presentation/screens/books_/bookList/bookWebPage.dart';

class bookList extends StatefulWidget {
  final String bookType;
  const bookList({super.key, required this.bookType});

  @override
  State<bookList> createState() => _bookListState();
}

class _bookListState extends State<bookList> {
  List<dynamic> books = [];
  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('books')
        .doc('OK4Xx3TE6ovk0ODbfNqt');

    final DocumentSnapshot snapshot = await documentReference.get();
    if (snapshot.exists) {
      setState(() {
        books = snapshot.get('books');
      });
      for (var book in books) {
        final String title = book['title'];
        final String url = book['url'];
        print("Title: $title, URL: $url");
      }
    } else {
      print("No books found.");
    }
  }

  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.3,
              minHeight: MediaQuery.of(context).size.width * 0.3,
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookWebPage(url: books[index]['url']),
                  ),
                );
              },
              child: Container(
                child: Column(children: [Text(books[index]['title'])]),
              ),
            ),
          );
        },
      ),
    );
  }
}
