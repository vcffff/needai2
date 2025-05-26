import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:needai/features/chat_forstudents/presentation/chatpage2.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Пользователи')),
      body: StreamBuilder<List<types.User>>(
        stream: FirebaseChatCore.instance.users(),
        builder: (context, snapshot) {
          print('UsersPage StreamBuilder state: ${snapshot.connectionState}');
          print('UsersPage StreamBuilder data: ${snapshot.data}');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Ошибка в UsersPage StreamBuilder: ${snapshot.error}');
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('Нет доступных пользователей');
            return const Center(child: Text('Нет доступных пользователей'));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              print(
                'User $index: id=${user.id}, firstName=${user.firstName}, lastName=${user.lastName}, role=${user.role}, metadata=${user.metadata}',
              );
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      user.imageUrl != null
                          ? NetworkImage(user.imageUrl!)
                          : null,
                  child:
                      user.imageUrl == null ? const Icon(Icons.person) : null,
                ),
                title: Text(user.firstName ?? 'No Name'),
                subtitle: Text(user.lastName ?? 'No Last Name'),
                trailing: Text(
                  user.role?.toString().split('.').last ?? 'No Role',
                ),
                onTap: () async {
                  try {
                    final room = await FirebaseChatCore.instance.createRoom(
                      user,
                    );
                    print('Чат создан для пользователя ${user.id}: ${room.id}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChatPage(room: room)),
                    );
                  } catch (e) {
                    print('Ошибка при создании чата: $e');
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
