import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

import 'chatpage2.dart'; // страница чата
import 'chatforstudents.dart'; // список юзеров

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  void initState() {
    super.initState();
    _ensureUserLoggedIn();
  }

  Future<void> _ensureUserLoggedIn() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      try {
        await FirebaseAuth.instance.signInAnonymously();
        debugPrint(
          '✅ Анонимный вход: ${FirebaseAuth.instance.currentUser?.uid}',
        );
      } catch (e) {
        debugPrint('❌ Ошибка анонимного входа: $e');
      }
    }
  }

  Future<void> createTestChat(BuildContext context) async {
    try {
      // Проверка аутентификации
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
        currentUser = FirebaseAuth.instance.currentUser;
      }

      if (currentUser == null) throw Exception('Не удалось войти');

      // Генерация случайного userId
      final testUserId = const Uuid().v4();

      // Создание тестового пользователя
      final testUser = types.User(
        id: testUserId,
        firstName: 'Test',
        lastName: 'User',
        imageUrl: 'https://i.pravatar.cc/150?img=3',
        role: types.Role.user,
        metadata: {'createdAt': DateTime.now().toIso8601String()},
      );
      await FirebaseChatCore.instance.createUserInFirestore(testUser);
      debugPrint('👤 Тестовый пользователь создан: ${testUser.id}');

      // Создание комнаты
      final room = await FirebaseChatCore.instance.createRoom(testUser);
      debugPrint('📦 Комната создана: ${room.id}');

      // Отправка сообщения
      final message = types.TextMessage(
        author: types.User(id: currentUser.uid),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Hello, this is a test message!',
        roomId: room.id,
      );
      FirebaseChatCore.instance.sendMessage(message, room.id);
      debugPrint('📩 Тестовое сообщение отправлено');
    } catch (e, stack) {
      debugPrint('❌ Ошибка при создании тестового чата: $e');
      debugPrint(stack.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Чаты'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersPage()),
              );
            },
            tooltip: 'Найти пользователей',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => createTestChat(context),
            tooltip: 'Создать тестовый чат',
          ),
        ],
      ),
      body: StreamBuilder<List<types.Room>>(
        stream: FirebaseChatCore.instance.rooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ошибкыыа: ${snapshot.error}'));
          }

          final rooms = snapshot.data ?? [];

          if (rooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text('Нет доступных чатов'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => createTestChat(context),
                    child: const Text('Создать тестовый чат'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UsersPage()),
                      );
                    },
                    child: const Text('Найти пользователей'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      (room.imageUrl != null && room.imageUrl!.isNotEmpty)
                          ? NetworkImage(room.imageUrl!)
                          : null,
                  child:
                      (room.imageUrl == null || room.imageUrl!.isEmpty)
                          ? const Icon(Icons.person)
                          : null,
                ),
                title: Text(room.name ?? 'Без имени'),
                subtitle: Text(room.id),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChatPage(room: room)),
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
