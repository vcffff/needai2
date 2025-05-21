
import 'package:needai/features/chatbot/data/models/modelofmessage.dart';

class ChatState {
  List<Modelofmessage>messages;
  ChatState({required this.messages});
  ChatState copy({List<Modelofmessage>?messages}){
    return ChatState(messages: messages??this.messages);
  }
}