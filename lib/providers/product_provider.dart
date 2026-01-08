import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();
  List<Product> products = [];
  bool loading = false;
  String? error;

  /// Ambil semua produk dari backend
  Future<void> fetchProducts() async {
    loading = true;
    notifyListeners();

    try {
      products = await _service.getProducts();
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Tambah produk baru
  Future<void> addProduct(Product product) async {
    loading = true;
    notifyListeners();

    try {
      final newProduct = await _service.createProduct(product);
      products.add(newProduct); // otomatis masuk ke list
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Update produk
  Future<void> updateProduct(int id, Product product) async {
    loading = true;
    notifyListeners();

    try {
      final updatedProduct = await _service.updateProduct(id, product);
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) products[index] = updatedProduct;
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Hapus produk
  Future<void> deleteProduct(int id) async {
    loading = true;
    notifyListeners();

    try {
      await _service.deleteProduct(id);
      products.removeWhere((p) => p.id == id);
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
