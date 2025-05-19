import 'package:needai/presentation/screens/chatbot/data/models/modelofmessage.dart' show Modelofmessage;

class ChatState {
  List<Modelofmessage>messages=[];
  ChatState({required this.messages});
  ChatState copy({List<Modelofmessage>?messages}){
    return ChatState(messages: messages??this.messages);
  }
}