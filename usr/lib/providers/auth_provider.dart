import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool get isLoggedIn => _currentUser != null;
  User? get currentUser => _currentUser;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if (username != null) {
      _currentUser = User(username: username, password: '');
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    // Mock login - in real app, verify with backend
    if (username.isNotEmpty && password.isNotEmpty) {
      _currentUser = User(username: username, password: password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signup(String username, String password) async {
    // Mock signup - in real app, create account on backend
    if (username.isNotEmpty && password.isNotEmpty) {
      return await login(username, password);
    }
    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    notifyListeners();
  }
}