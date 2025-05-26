import 'package:cloud_firestore/cloud_firestore.dart';

class MessageofStudent {
  final String senderid;
  final String senderemail;
  final String receiverid;
  final String message;
  final Timestamp timestamp;

  MessageofStudent({required this.senderid, required this.senderemail, required this.receiverid, required this.message, required this.timestamp});

  //Service
  Map<String,dynamic>toMap(){
    return {
      "senderid":senderid,
      "senderemail":senderemail,
      "receiverid":receiverid,
      "timestamp":timestamp,
      "message":message 
    };
  }
}