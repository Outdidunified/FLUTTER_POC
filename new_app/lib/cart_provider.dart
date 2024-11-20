import 'package:flutter/material.dart';
import 'cart_item_model.dart';
import 'cart_repository.dart';

class CartProvider with ChangeNotifier {
  List<CartItemModel> _cartItems = [];
  bool _loading = false;
  String _errorMessage = '';

  List<CartItemModel> get cartItems => _cartItems;
  bool get loading => _loading;
  String get errorMessage => _errorMessage;

  final CartRepository _cartRepository = CartRepository();

  Future<void> fetchCart(String userId) async {
    _loading = true;
    notifyListeners();

    try {
      _cartItems = await _cartRepository.fetchCartForUser(userId);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(CartItemModel cartItem, String userId) async {
    _loading = true;
    notifyListeners();

    try {
      _cartItems = await _cartRepository.addToCart(cartItem, userId);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> removeFromCart(String productId, String userId) async {
    _loading = true;
    notifyListeners();

    try {
      _cartItems = await _cartRepository.removeFromCart(productId, userId);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
