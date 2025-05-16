import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Books extends StatefulWidget {
  const Books({super.key});

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  @override
  Widget build(BuildContext context) {
    return TypeOfBooks();
  }
}

class TypeOfBooks extends StatefulWidget {
  const TypeOfBooks({super.key});

  @override
  State<TypeOfBooks> createState() => _TypeOfBooksState();
}

class _TypeOfBooksState extends State<TypeOfBooks> {
  List<dynamic> typesOfBooks = [];

  @override
  void initState() {
    super.initState();
    fetchTypes();
  }

  Future<void> fetchTypes() async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('books')
        .doc('typesOfBooks');

    final DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      setState(() {
        typesOfBooks = snapshot.get('types');
      });
    } else {
      print("No books found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: typesOfBooks.length,
      itemBuilder: (context, i) {
        return Card(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Colors.grey),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              leading: Container(
                padding: const EdgeInsets.only(right: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(width: 1, color: Colors.grey),
                  ),
                ),
                child: const Icon(Icons.book, color: Colors.white),
              ),
              title: Text(typesOfBooks[i]),
            ),
          ),
        );
      },
    );
  }
}









// class Books extends StatefulWidget {
//   const Books({super.key});

//   @override
//   State<Books> createState() => _BooksState();
// }

// class _BooksState extends State<Books> {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   int current = 0;
//   int total = 0;
//   PdfControllerPinch? pdfControllerPinch;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();

//     if (!kIsWeb) {
//       loadPdf();
//     }
//   }
//   Future<void> loadPdf() async {
//     try {
//       final document = PdfDocument.openAsset('assets/pdfs/sat.vocab.pdf');
//       setState(() {
//         pdfControllerPinch = PdfControllerPinch(document: document);
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Failed to load PDF: $e';
//       });
//     }
//   }
//   @override
//   void dispose() {
//     pdfControllerPinch?.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Books')),
//       body: BooksDisplay(),
//     );
//   }
//   Column pdfFirst() {
//     return Column(
//       children: [
//         errorMessage != null
//             ? Center(child: Text(errorMessage!))
//             : pdfControllerPinch == null
//             ? const Center(child: CircularProgressIndicator())
//             : PdfViewPinch(
//               scrollDirection: Axis.horizontal,
//               onPageChanged: (page) {
//                 setState(() {
//                   current = page;
//                 });
//               },
//               controller: pdfControllerPinch!,
//               onDocumentLoaded: (page) {
//                 setState(() {
//                   total = page.pagesCount;
//                 });
//               },
//             ),
//       ],
//     );
//   }
// }