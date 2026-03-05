import 'package:e_commerce_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/services/api_client.dart';

class UserProvider extends ChangeNotifier {
  // --- User Info State ---
  String _username = "Guest";
  bool _isUserLoading = false;

  String get username => _username;
  bool get isUserLoading => _isUserLoading;

  // --- Product Feed State ---
  List<Product> _allProducts = [];
  int _skip = 0;
  final int _limit = 10;
  bool _isProductLoading = false;
  bool _hasMore = true;

  List<Product> get allProducts => _allProducts;
  bool get isProductLoading => _isProductLoading;
  bool get hasMore => _hasMore;

  // --- Functions ---

  /// Fetches the username for the current session
  Future<void> refreshUsername() async {
    _isUserLoading = true;
    notifyListeners();
    try {
      final response = await ApiClient.dio.get("/username");
      if (response.statusCode == 200) {
        _username = response.data['username'];
      }
    } catch (e) {
      debugPrint("Error fetching username: $e");
    } finally {
      _isUserLoading = false;
      notifyListeners();
    }
  }

  /// Fetches the next page of products from the feed
  Future<void> fetchItems() async {
    // Avoid redundant calls
    if (_isProductLoading || !_hasMore) return;

    _isProductLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient.dio.get('/items/feed?skip=$_skip&limit=$_limit');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        
        if (data.isEmpty) {
          _hasMore = false;
        } else {
          final List<Product> newItems = data.map((json) => Product.fromJson(json)).toList();
          _allProducts.addAll(newItems);
          _skip += _limit;
        }
      }
    } catch (e) {
      debugPrint("Error Fetching data: $e");
      // If the backend returns 404 or error when no more items exist
      _hasMore = false;
    } finally {
      _isProductLoading = false;
      notifyListeners();
    }
  }

  /// Resets the feed and fetches from the beginning (for Pull-to-Refresh)
  Future<void> refreshFeed() async {

    _isProductLoading = false;

    _allProducts = [];
    _skip = 0;
    _hasMore = true;

    notifyListeners();

    await fetchItems();
  }
}