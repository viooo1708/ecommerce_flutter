// services/cart_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.dart';

class CartService {
  // Ganti sesuai device kamu
  // final String baseUrl = 'http://10.0.2.2:8000'; // Android emulator
  // final String baseUrl = 'http://127.0.0.1:8000'; // iOS / Web
  // Untuk Flutter Web (akses Docker dari host PC)
  static const String baseUrl = 'http://192.168.18.65:8000';

  Future<List<CartItem>> getCarts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/carts'), // pastikan route ini benar
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      // INI YANG PENTING: ambil dari key 'data'
      final List<dynamic> data =
          jsonResponse['items'] ?? jsonResponse['carts'] ?? [];

      return data.map((item) => CartItem.fromJson(item)).toList();
    } else {
      throw Exception(
        'Gagal memuat keranjang (Status: ${response.statusCode})',
      );
    }
  }
}
