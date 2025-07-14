import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _selectedUser = '';

  String get selectedUser => _selectedUser;

  void setSelectedUser(String name) {
    _selectedUser = name;
    notifyListeners();
  }
}
