
import 'package:flutter/material.dart';
import 'package:needai/data/services/services.dart';

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


}

