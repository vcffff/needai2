import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needai/presentation/screens/books_/bookList/booksList.dart';

class Books extends StatelessWidget {
  const Books({super.key});

  @override
  Widget build(BuildContext context) {
    return const TypeOfBooks();
  }
}

class TypeOfBooks extends StatelessWidget {
  const TypeOfBooks({super.key});

  Future<List<String>> fetchTypes() async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('books')
        .doc('typesOfBooks');

    try {
      final DocumentSnapshot snapshot = await documentReference.get();
      if (snapshot.exists) {
        final List<dynamic>? types = snapshot.get('types');
        return types != null ? List<String>.from(types) : [];
      } else {
        print("No books found.");
        return [];
      }
    } catch (e) {
      print("Error fetching books: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchTypes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No book types found.'));
        } else {
          final typesOfBooks = snapshot.data!;
          return ListView.builder(
            itemCount: typesOfBooks.length,
            itemBuilder: (context, i) {
              return Card(
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  onTap: () {
                    print(typesOfBooks[i]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => bookList(bookType: typesOfBooks[i]),
                      ),
                    );
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  leading: const Icon(Icons.book, color: Colors.black),
                  title: Text(typesOfBooks[i]),
                ),
              );
            },
          );
        }
      },
    );
  }
}
