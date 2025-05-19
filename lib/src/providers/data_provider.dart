import 'package:flutter/material.dart';
class DataProvider extends ChangeNotifier {
  String? _userEmail;

  String? get userEmail => _userEmail;

  void adduser(String email) {
    _userEmail = email;
    notifyListeners();
  }
}
