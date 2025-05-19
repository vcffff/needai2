import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int currentPage;
  final ValueChanged<int> onChanged;

  const BottomBar({
    super.key,
    required this.currentPage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentPage,
      onTap: onChanged,
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
          label: 'Message',
          icon: Icon(CupertinoIcons.conversation_bubble, color: Colors.blueAccent),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(CupertinoIcons.profile_circled, color: Colors.blueAccent),
        ),
      ],
    );
  }
}
