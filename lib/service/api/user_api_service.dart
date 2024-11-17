import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:labs/entity/user.dart';

class UserApiService {
  final String baseUrl;
  static final UserApiService _instance = UserApiService
      ._internal('http://localhost:8080');

  factory UserApiService() {
    return _instance;
  }

  UserApiService._internal(this.baseUrl);

  Future<User?> getUserByEmail(String email) async {
    final response = await http.get(Uri.parse('$baseUrl/users?email=$email'));

    if (response.statusCode == 200) {
      try {
        if (response.body.isNotEmpty) {
          final Map<String, dynamic> userJson = jsonDecode(response.body)
          as Map<String, dynamic>;
          return User.fromJson(userJson);
        } else {
          throw const FormatException('Empty response body');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error decoding JSON: $e');
        }
        return null;
      }
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}');
      }
      return null;
    }
  }

  Future<void> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create user');
    }
  }

  Future<List<User>> getAllUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> usersJson =
      jsonDecode(response.body) as List<dynamic>;
      return usersJson.map((json) =>
          User.fromJson(json as Map<String, dynamic>),)
          .toList();
    } else {
      return [];
    }
  }
}
