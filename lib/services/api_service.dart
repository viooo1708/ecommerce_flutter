// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/product.dart';
//
// class ApiService {
//   // Use 10.0.2.2 for Android emulator to access host machine's localhost
//   final String baseUrl = 'http://192.168.18.65:3000';
//
//   Future<List<Product>> getProducts() async {
//     final response = await http.get(Uri.parse('$baseUrl/products'));
//
//     if (response.statusCode == 200) {
//       Iterable list = json.decode(response.body);
//       return list.map((model) => Product.fromJson(model)).toList();
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }
//
//   Future<Product> getProductById(int id) async {
//     final response = await http.get(Uri.parse('$baseUrl/products/$id'));
//
//     if (response.statusCode == 200) {
//       return Product.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to load product');
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // static const String baseUrl = 'http://localhost:3000';
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        return (data['data'] as List).map((json) => Product.fromJson(json)).toList();
      }
    }
    throw Exception('Failed to load products');
  }

  Future<Product> getProduct(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        return Product.fromJson(data['data']);
      }
    }
    throw Exception('Failed to load product');
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        return Product.fromJson(data['data']);
      }
    }
    throw Exception('Failed to create product');
  }

  Future<Product> updateProduct(int id, Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        return Product.fromJson(data['data']);
      }
    }
    throw Exception('Failed to update product');
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}
