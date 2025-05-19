import 'package:bloc/bloc.dart';
import 'package:needai/src/features/chatbot/bussines_logic/bloc/chat_event.dart';
import 'package:needai/src/features/chatbot/bussines_logic/bloc/chat_state.dart';
import 'package:needai/src/features/chatbot/data/messages/auto_messages.dart';
import 'package:needai/src/features/chatbot/data/models/modelofmessage.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  int current = 0;

  ChatBloc() : super(ChatState(messages: [])) {
    on<Userzhazdi>(onuser);
  }

  Future<void> onuser(Userzhazdi event, Emitter<ChatState> emit) async {
    final updatedMessages = List<Modelofmessage>.from(state.messages)
      ..add(Modelofmessage(
        message: event.message,
        isuser: true,
        imagePath: event.imagepath, 
      ));
    emit(state.copy(messages: updatedMessages));

    await Future.delayed(Duration(seconds: 1));

    final reply = fakemessage(event.message);

    updatedMessages.add(Modelofmessage(
      message: "Привет! Я понял, вот что могу подсказать по твоему вопросу 👇",
      isuser: false,
    ));


    updatedMessages.add(Modelofmessage(
      message: reply.text,
      isuser: false,
      imagePath: reply.imagePath,
    ));

    emit(state.copy(messages: updatedMessages));
  }

  _Reply fakemessage(String input) {
    final lowerInput = input.toLowerCase();

    if (lowerInput.contains("sat")) {
      return _Reply(
        text: messages.firstWhere((m) => m.toLowerCase().contains("sat")),
        imagePath: 'assets/images/sat_example.png',
      );
    } else if (lowerInput.contains("ielts")) {
      return _Reply(
        text: messages.firstWhere((m) => m.toLowerCase().contains("ielts")),
        imagePath: 'assets/images/ielts_tip.png',
      );
    } else {
      return _Reply(
        text: messages[current++ % messages.length],
        imagePath: null,
      );
    }
  }
}

class _Reply {
  final String text;
  final String? imagePath;

  _Reply({required this.text, this.imagePath});
}
