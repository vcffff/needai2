import 'package:flutter/material.dart';
class DataProvider  extends ChangeNotifier{
  List<String>users=[];
void adduser(String input){
  users.add(input);
  notifyListeners();
}
}