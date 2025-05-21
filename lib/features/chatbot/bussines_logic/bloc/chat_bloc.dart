import 'package:bloc/bloc.dart';
import 'package:needai/features/chatbot/bussines_logic/bloc/chat_event.dart';
import 'package:needai/features/chatbot/bussines_logic/bloc/chat_state.dart';
import 'package:needai/features/chatbot/data/messages/auto_messages.dart';
import 'package:needai/features/chatbot/data/models/modelofmessage.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  int current = 0;

  ChatBloc() : super(ChatState(messages: [])) {
    on<Userzhazdi>(onuser);
  }

  Future<void> onuser(event, emit) async {
    final updatedMessages = List<Modelofmessage>.from(state.messages)
      ..add(Modelofmessage(message: event.message, isuser: true));
    emit(state.copy(messages: updatedMessages));

    await Future.delayed(Duration(seconds: 1));

    final reply = fakemessage(event.message);

    updatedMessages.add(
      Modelofmessage(
        message:
            "Привет! Я понял, вот что могу подсказать по твоему вопросу 👇",
        isuser: false,
      ),
    );

    updatedMessages.add(Modelofmessage(message: reply.text, isuser: false));

    emit(state.copy(messages: updatedMessages));
  }

  Reply fakemessage(String input) {
    final lowerInput = input.toLowerCase();

    if (lowerInput.contains("sat")) {
      return Reply(
        text: messages.firstWhere((m) => m.toLowerCase().contains("sat")),
      );
    } else if (lowerInput.contains("ielts")) {
      return Reply(
        text: messages.firstWhere((m) => m.toLowerCase().contains("ielts")),
      );
    } else {
      return Reply(text: messages[current++ % messages.length]);
    }
  }
}
