import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:needai/features/teachers/presentation/teacherchatpage.dart';

class TeacherInboxPage extends StatefulWidget {
  const TeacherInboxPage({super.key});

  @override
  State<TeacherInboxPage> createState() => _TeacherInboxPageState();
}

class _TeacherInboxPageState extends State<TeacherInboxPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> _getUserName(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return userDoc.data()?['name'] ?? userDoc.data()?['firstName'] ?? userId;
    } catch (e) {
      return userId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.message, color: Colors.white),
        centerTitle: true,
        title: Text(
          'Входящие сообщения',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            _firestore
                .collection('chats')
                .where('participants', arrayContains: _auth.currentUser!.uid)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Ошибка загрузки чатов'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return const Center(child: Text('Нет чатов'));
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index].data() as Map<String, dynamic>;
              final chatId = chats[index].id;
              final otherUserId = (chat['participants'] as List<dynamic>)
                  .firstWhere((id) => id != _auth.currentUser!.uid);

              return FutureBuilder<String>(
                future: _getUserName(otherUserId),
                builder: (context, nameSnapshot) {
                  final userName = nameSnapshot.data ?? otherUserId;

                  return ListTile(
                    title: Text(
                      'Чат с $userName',
                      style: GoogleFonts.poppins(),
                    ),
                    subtitle: Text(
                      chat['lastMessage'] ?? 'Нет сообщений',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => TeacherChatPage(
                                otherUserId: otherUserId,
                                isTeacher: true,
                              ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
