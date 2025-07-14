import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _selectedUser = '';
  String? _selectedUserEmail;
  String? _selectedUserAvatar;

  String get selectedUser => _selectedUser;
  String? get selectedUserEmail => _selectedUserEmail;
  String? get selectedUserAvatar => _selectedUserAvatar;

  // Untuk tetap kompatibel dengan pemanggilan lama
  void setSelectedUser(String name) {
    _selectedUser = name;
    notifyListeners();
  }

  // Untuk menyimpan data lengkap user
  void setSelectedUserData(String name, String email, String avatar) {
    _selectedUser = name;
    _selectedUserEmail = email;
    _selectedUserAvatar = avatar;
    notifyListeners();
  }

  // Opsional: Reset selected user (jika dibutuhkan)
  void clearSelectedUser() {
    _selectedUser = '';
    _selectedUserEmail = null;
    _selectedUserAvatar = null;
    notifyListeners();
  }
}