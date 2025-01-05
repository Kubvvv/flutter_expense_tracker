import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _username = '';
  int? _userId;

  String get username => _username;
  int? get userId => _userId;

  void login(int userId, String username) {
    _userId = userId;
    _username = username;
    notifyListeners();
  }

  void logout() {
    _userId = null;
    _username = '';
    notifyListeners();
  }
}
