import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:needai/data/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddToFavourites extends ChangeNotifier {
  final List<oneCourse> _favourites = [];

  List<oneCourse> get favourites => _favourites;

  void addToFav(oneCourse course) {
    if (!_favourites.contains(course)) {
      _favourites.add(course);
      notifyListeners();
    }
  }

  void removeFromFav(oneCourse cource) {
    _favourites.remove(cource);
    notifyListeners();
  }

  bool isFavourite(oneCourse course) {
    return _favourites.contains(course);
  }

  Future<void> savefav() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favjson =
        _favourites.map((course) => jsonEncode(course.toJson())).toList();
    prefs.setStringList('favorites', favjson);
  }

  Future<void> loadfav() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favJson = prefs.getStringList('favorites');
    if (favJson != null) {
      _favourites.clear();
      _favourites.addAll(
        favJson.map((c) => oneCourse.fromJson(jsonDecode(c))).toList(),
      );
      notifyListeners();
    }
  }
}
