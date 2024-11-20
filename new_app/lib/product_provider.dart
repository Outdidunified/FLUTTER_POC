import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product_model.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<ProductModel> get products => _filteredProducts.isEmpty ? _products : _filteredProducts;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final String baseUrl = "http://192.168.1.103:5000/api"; // Replace with your base URL

  // Fetch all products directly within the provider using http
  Future<void> fetchAllProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Perform the GET request using the http package
      final response = await http.get(Uri.parse('$baseUrl/product'));

      if (response.statusCode == 200) {
        // If server returns a 200 OK response, parse the data
        final Map<String, dynamic> apiResponse = json.decode(response.body);

        if (!apiResponse['success']) {
          throw apiResponse['message'].toString();
        }

        // Map the response data to ProductModel
        _products = (apiResponse['data'] as List<dynamic>)
            .map((json) => ProductModel.fromJson(json))
            .toList();

        _filteredProducts = _products; // Set initial list to be the full list
      } else {
        throw 'Failed to load products';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search for products based on the search query
  void searchProducts(String query) {
    _filteredProducts = _products.where((product) {
      return product.description != null &&
          product.description!.toLowerCase().contains(query.toLowerCase());
    }).toList();
    notifyListeners();
  }
}
