abstract class ChatEvent {}
class Userzhazdi extends ChatEvent{
  final String message;
  Userzhazdi(this.message);
}