import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:needai/presentation/screens/chatbot/bussines_logic/bloc/chat_bloc.dart';
import 'package:needai/presentation/screens/chatbot/bussines_logic/bloc/chat_event.dart';
import 'package:needai/presentation/screens/chatbot/bussines_logic/bloc/chat_state.dart';
import 'package:needai/presentation/screens/chatbot/data/images/images.dart';
import 'package:needai/presentation/themes/colors.dart';

class Uipage extends StatefulWidget {
  const Uipage({super.key});

  @override
  State<Uipage> createState() => _UipageState();
}

class _UipageState extends State<Uipage> with SingleTickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();
  File? selectedimagepath;
  final ImagePicker picker = ImagePicker();
  String? selectedImagePath;
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
                              if (message.imagePath != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Image.asset(message.imagePath!),
                                ),
                            ],
                          ),
                        ),
                      );
                    }

                    return AnimatedMessage(key: ValueKey(index), child: child);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.image,
                    color:
                        selectedImagePath != null ? Colors.green : Colors.grey,
                  ),
                  onPressed: () {
                    final Random random = Random();
                    setState(() {
                      selectedImagePath = images[random.nextInt(2)];
                    });
                  },
                ),

                Expanded(child: TextField(controller: controller)),

                IconButton(
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isNotEmpty) {
                      context.read<ChatBloc>().add(
                        Userzhazdi(text, selectedImagePath),
                      );
                      controller.clear();
                      setState(() {
                        selectedImagePath = null;
                      });
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

class AnimatedMessage extends StatefulWidget {
  final Widget child;

  const AnimatedMessage({required this.child, super.key});

  @override
  State<AnimatedMessage> createState() => _AnimatedMessageState();
}

class _AnimatedMessageState extends State<AnimatedMessage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
