import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  User? _currentUser;
  final AuthService _authService = AuthService();
  User? get currentUser => _currentUser;

  Future<bool> login(String username, String password) async {
    final user = await _authService.login(username, password);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
