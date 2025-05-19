abstract class ChatEvent {}
class Userzhazdi extends ChatEvent{
  final String message;
  final String? imagepath;
  Userzhazdi(this.message,[this.imagepath]);
}