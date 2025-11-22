import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // Use 10.0.2.2 for Android emulator to access host machine's localhost
  final String baseUrl = 'http://192.168.18.65:3000';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Product.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> getProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }
}
