import 'package:flutter/material.dart';
import 'package:e_commerce_app/services/api_client.dart';

class UserProvider extends ChangeNotifier {
  String _username = "Guest";
  bool _isLoading = false;

  String get username => _username;
  bool get isLoading => _isLoading;

  // Function to fetch and update the name
  Future<void> refreshUsername() async {
    _isLoading = true;
    notifyListeners(); // Tells the UI to show a loading spinner

    try {
      final response = await ApiClient.dio.get("/username");
      if (response.statusCode == 200) {
        _username = response.data['username'];
      }
    } catch (e) {
      debugPrint("Error fetching username: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Tells the UI to show the actual name
    }
  }
}