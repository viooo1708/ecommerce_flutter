import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String baseUrl = 'http://10.0.2.2:10001';

  /// ===============================
  /// GET: Ambil semua produk
  /// ===============================
  Future<List<Product>> getProducts() async {
    final res = await http.get(Uri.parse('$baseUrl/products'));

    print('GET /products => ${res.statusCode}');
    print('Body: ${res.body}');

    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      final data = jsonData['data'] as List?;
      if (data == null) return []; // jika backend tidak mengirim data
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products: ${res.statusCode}');
    }
  }

  /// ===============================
  /// POST: Tambah produk baru
  /// ===============================
  Future<Product> createProduct(Product product) async {
    final res = await http.post(
      Uri.parse('$baseUrl/products'),
      body: jsonEncode(product.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    print('POST /products => ${res.statusCode}');
    print('Body: ${res.body}');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData = jsonDecode(res.body);
      if (jsonData['data'] == null) {
        throw Exception('Backend returned null data on create');
      }
      return Product.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to create product: ${res.statusCode}');
    }
  }

  /// ===============================
  /// PUT: Update produk
  /// ===============================
  Future<Product> updateProduct(int id, Product product) async {
    final res = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      body: jsonEncode(product.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    print('PUT /products/$id => ${res.statusCode}');
    print('Body: ${res.body}');

    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      if (jsonData['data'] == null) {
        throw Exception('Backend returned null data on update');
      }
      return Product.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to update product: ${res.statusCode}');
    }
  }

  /// ===============================
  /// DELETE: Hapus produk
  /// ===============================
  Future<void> deleteProduct(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/products/$id'));

    print('DELETE /products/$id => ${res.statusCode}');
    print('Body: ${res.body}');

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Failed to delete product: ${res.statusCode}');
    }
  }
}
