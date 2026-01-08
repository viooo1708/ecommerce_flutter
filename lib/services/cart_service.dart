import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.dart';

class CartService {
  static const String baseUrl = 'http://192.168.18.65:8000/cart';

  Future<List<CartItem>> getCart() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body)['data'] as List;
      return data.map((e) => CartItem.fromJson(e)).toList();
    }
    return [];
  }

  Future<CartItem> addToCart(CartItem item) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode(item.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return CartItem.fromJson(jsonDecode(res.body)['data']);
    }
    // Kalau gagal, tetap kembalikan local item supaya UI update
    return item;
  }
}
