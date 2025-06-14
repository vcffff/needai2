import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:needai/features/teachers/presentation/demoteacher.dart';
import 'package:needai/firebase_options.dart';
import 'package:needai/features/auth/presentation/auth.dart';
import 'package:needai/features/books/presentation/bookList/books.dart';
import 'package:needai/features/favourites/presentation/favourites.dart';
import 'package:needai/features/home/presentation/firstpage.dart';
import 'package:needai/features/profile/presentation/profilepage.dart';
import 'package:needai/features/teachers/presentation/teacher.dart';
import 'package:needai/features/courses/presentation/courses.dart';
import 'package:needai/features/chatbot/bussines_logic/bloc/chat_bloc.dart';
import 'package:needai/features/chatbot/presentation/chat.dart';
import 'package:needai/core/providers/data_provider.dart';
import 'package:needai/core/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AddToFavourites()),
          ChangeNotifierProvider(create: (_) => DataProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
          home: Authourization(),
        ),
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
    //chat bot
    Uipage(),
    //teacherpage
    TeachersPage(),

    //demoteacher
    TeacherInboxPage(),
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
          BottomNavigationBarItem(
            label: 'ChatBot',
            icon: Icon(Icons.smart_toy, color: Colors.blueAccent),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin, color: Colors.blueAccent),
            label: "Teachers",
          ),
        
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: "Inbox",
          ),
        ],
      ),
    );
  }
}
