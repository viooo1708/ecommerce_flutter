import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  static const String baseUrl = 'http://192.168.18.65:4000/users';

  /// ===============================
  /// GET: Ambil semua user
  /// ===============================
  Future<List<User>> getUsers() async {
    final res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users: ${res.statusCode}');
    }
  }

  /// ===============================
  /// POST: Tambah user baru
  /// ===============================
  Future<User> createUser(User user) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (res.statusCode == 201 || res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      return User.fromJson(jsonData);
    } else {
      throw Exception('Failed to create user: ${res.statusCode}');
    }
  }

  /// ===============================
  /// PUT: Update user
  /// ===============================
  Future<User> updateUser(int id, User user) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      return User.fromJson(jsonData);
    } else {
      throw Exception('Failed to update user: ${res.statusCode}');
    }
  }

  /// ===============================
  /// DELETE: Hapus user
  /// ===============================
  Future<void> deleteUser(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Failed to delete user: ${res.statusCode}');
    }
  }
}
