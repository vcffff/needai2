import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeacherChatPage extends StatefulWidget {
  final String otherUserId;
  final bool isTeacher;
  const TeacherChatPage({
    super.key,
    required this.otherUserId,
    this.isTeacher = false,
  });

  @override
  State<TeacherChatPage> createState() => _TeacherChatPageState();
}

class _TeacherChatPageState extends State<TeacherChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getChatId(String userA, String userB) {
    final ids = [userA, userB]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      final chatId = getChatId(_auth.currentUser!.uid, widget.otherUserId);
      try {
        await _firestore.collection('chats').doc(chatId).set({
          'participants': [_auth.currentUser!.uid, widget.otherUserId],
          'lastMessage': _messageController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .add({
              'text': _messageController.text.trim(),
              'senderId': _auth.currentUser!.uid,
              'timestamp': FieldValue.serverTimestamp(),
            });
        _messageController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка отправки сообщения: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatId = getChatId(_auth.currentUser!.uid, widget.otherUserId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isTeacher
              ? 'Чат с учеником ${widget.otherUserId}'
              : 'Чат с преподавателем ${widget.otherUserId}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  _firestore
                      .collection('chats')
                      .doc(chatId)
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Ошибка загрузки сообщений'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                final filteredMessages =
                    widget.isTeacher
                        ? messages
                        : messages
                            .where(
                              (message) =>
                                  message['senderId'] == _auth.currentUser!.uid,
                            )
                            .toList();

                if (filteredMessages.isEmpty) {
                  return const Center(child: Text('Нет сообщений'));
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: filteredMessages.length,
                  itemBuilder: (context, index) {
                    final message = filteredMessages[index];
                    final isMe = message['senderId'] == _auth.currentUser?.uid;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blueAccent : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message['text'],
                          style: GoogleFonts.poppins(
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Введите сообщение...',
                      hintStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
