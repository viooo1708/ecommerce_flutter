import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _service = CartService();
  List<CartItem> items = [];
  bool loading = false;
  String? error;

  CartProvider() {
    fetchCart(); // otomatis ambil cart saat provider dibuat
  }

  Future<void> fetchCart() async {
    loading = true;
    notifyListeners();
    try {
      items = await _service.getCart();
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(CartItem item) async {
    try {
      final index = items.indexWhere((e) => e.id == item.id);
      if (index != -1) {
        // kalau sudah ada, tambah quantity
        items[index].quantity += item.quantity;
        notifyListeners();
      } else {
        // jika belum ada, panggil API dan tambahkan
        final added = await _service.addToCart(item);
        items.add(added);
        notifyListeners();
      }
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  void removeFromCart(int productId) {
    items.removeWhere((e) => e.id == productId);
    notifyListeners();
  }

  double get total => items.fold(0, (sum, item) => sum + (item.price * item.quantity));
}
