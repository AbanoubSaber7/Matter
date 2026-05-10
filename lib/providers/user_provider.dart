import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _name = "Guest User";
  String _email = "guest@example.com";
  String _phone = "";

  String get name => _name;
  String get email => _email;
  String get phone => _phone;

  void setUser(String name, String email, {String phone = ""}) {
    _name = name;
    _email = email;
    _phone = phone;
    notifyListeners();
  }
}
