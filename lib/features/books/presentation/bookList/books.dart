import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:needai/features/books/presentation/bookList/booksList.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.reddit_sharp),
        title: Text('Available Books', style: TextStyle(fontSize: 20)),
      ),
      body: FutureBuilder<List<String>>(
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
                return InkWell(
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
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        child: Icon(
                          Icons.auto_stories_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      title: Text(
                        typesOfBooks[i],
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
