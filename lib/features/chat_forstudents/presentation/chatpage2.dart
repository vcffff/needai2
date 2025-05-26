import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_auth/firebase_auth.dart';


class ChatPage extends StatelessWidget {
  final types.Room room;

  const ChatPage({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('Пользователь не аутентифицирован на ChatPage');
      return const Scaffold(
        body: Center(child: Text('Ошибка: Пользователь не аутентифицирован')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(room.name ?? 'Chat')),
      body: StreamBuilder<List<types.Message>>(
        stream: FirebaseChatCore.instance.messages(room),
        builder: (context, snapshot) {
          print('ChatPage StreamBuilder state: ${snapshot.connectionState}');
          print('ChatPage StreamBuilder data: ${snapshot.data}');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Ошибка в ChatPage StreamBuilder: ${snapshot.error}');
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          return Chat(
            messages: snapshot.data ?? [],
            onSendPressed: (partial) {
              final message = types.TextMessage(
                author: types.User(id: currentUser.uid),
                createdAt: DateTime.now().millisecondsSinceEpoch,
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                text: partial.text,
                roomId: room.id,
              );
              FirebaseChatCore.instance.sendMessage(message, room.id);
            },
            user: types.User(id: currentUser.uid),
          );
        },
      ),
    );
  }
}
