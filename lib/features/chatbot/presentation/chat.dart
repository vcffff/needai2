
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:needai/features/chatbot/bussines_logic/bloc/chat_bloc.dart';
import 'package:needai/features/chatbot/bussines_logic/bloc/chat_event.dart';
import 'package:needai/features/chatbot/bussines_logic/bloc/chat_state.dart';
import 'package:needai/core/themes/colors.dart';

class Uipage extends StatefulWidget {
  const Uipage({super.key});

  @override
  State<Uipage> createState() => _UipageState();
}

class _UipageState extends State<Uipage> with SingleTickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Bot!'),
        leading: Icon(Icons.smart_toy, color: maincolor),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: state.messages.length + 1,
                  itemBuilder: (context, index) {
                    Widget child;

                    if (index == 0) {
                      child = Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: maincolor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '''Привет! Я твой AI ассистент, который поможет с уроками! 
Напиши SAT/IELTS/MATH''',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    } else {
                      final message = state.messages[index - 1];
                      child = Align(
                        alignment:
                            message.isuser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                message.isuser
                                    ? Colors.blue[200]
                                    : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.message,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                             
                            ],
                          ),
                        ),
                      );
                    }

                    return child;
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(child: TextField(controller: controller)),

                IconButton(
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isNotEmpty) {
                      context.read<ChatBloc>().add(
                        Userzhazdi(text, ),
                      );
                      controller.clear();
                     
                    }
                  },
                  icon: Icon(Icons.send_rounded, color: maincolor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
