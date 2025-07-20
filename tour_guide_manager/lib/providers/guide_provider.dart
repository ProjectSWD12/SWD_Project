import 'package:flutter/material.dart';
import 'package:tour_guide_manager/screens/profile.dart';

class GuideProvider extends ChangeNotifier {
  UserProfile? _guide;

  UserProfile? get guide => _guide;

  void setGuide(UserProfile guide) {
    _guide = guide;
    notifyListeners();
  }

  void clear() {
    _guide = null;
    notifyListeners();
  }
}
