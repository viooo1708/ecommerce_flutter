import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _service = UserService();

  List<User> users = [];
  String? error;
  bool isLoading = false;

  /// ===============================
  /// Ambil semua user
  /// ===============================
  Future<void> fetchUsers() async {
    isLoading = true;
    notifyListeners();

    try {
      users = await _service.getUsers();
      error = null;
    } catch (e) {
      error = e.toString();
      users = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ===============================
  /// Tambah user baru
  /// ===============================
  Future<bool> addUser(User user) async {
    try {
      final newUser = await _service.createUser(user);
      users.add(newUser);
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// ===============================
  /// Update user
  /// ===============================
  Future<bool> updateUser(User user) async {
    try {
      final updatedUser = await _service.updateUser(user.id, user);
      final index = users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        users[index] = updatedUser;
        notifyListeners();
      }
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// ===============================
  /// Hapus user
  /// ===============================
  Future<bool> deleteUser(int id) async {
    try {
      await _service.deleteUser(id);
      users.removeWhere((u) => u.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
