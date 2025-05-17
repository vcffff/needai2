import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:needai/presentation/screens/auth/auth.dart';
import 'package:needai/presentation/screens/books_/books.dart';
import 'package:needai/presentation/screens/courses/courses.dart';
import 'package:needai/presentation/screens/favourites/favourites.dart';
import 'package:needai/presentation/screens/firstpage/firstpage.dart';
import 'package:needai/presentation/screens/profilepage/profilepage.dart';
import 'package:needai/providers/data_provider.dart';
import 'package:needai/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:needai/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddToFavourites()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
        home: Authourization(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int current = 0;
  void changepage(int index) {
    setState(() {
      current = index;
    });
  }

  List<Widget> pages = [
    // Header Section
    Firstpage(),
    // White Card Section
    //books
    Books(),
    //list of cources
    Course(),

    //favourites
    FavoritesPage(),
    //profilepage
    Profilepage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[current],
      bottomNavigationBar: BottomNavigationBar(
        onTap: changepage,
        currentIndex: current,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(CupertinoIcons.home, color: Colors.blueAccent),
          ),
          BottomNavigationBarItem(
            label: 'Course',
            icon: Icon(CupertinoIcons.book, color: Colors.blueAccent),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(CupertinoIcons.search, color: Colors.blueAccent),
          ),
          BottomNavigationBarItem(
            label: 'Favourites',
            icon: Icon(CupertinoIcons.heart_fill, color: Colors.blueAccent),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(
              CupertinoIcons.profile_circled,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
