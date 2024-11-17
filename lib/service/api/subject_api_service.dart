import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:labs/entity/subject.dart';

class SubjectApiService {
  final String baseUrl;
  static final SubjectApiService _instance = SubjectApiService
      ._internal('https://76e85ddf272903ec1b3614c87e4f0b8b.serveo.net');

  factory SubjectApiService() {
    return _instance;
  }

  SubjectApiService._internal(this.baseUrl);

  Future<List<Subject>> getSubjectsByUserId(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/subjects/user/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> subjectsJson = jsonDecode(response.body) as
      List<dynamic>;
      return subjectsJson.map((json) {
        return Subject.fromJsonMap(json as Map<String, dynamic>);
      }).toList();
    } else {
      return [];
    }
  }

  Future<void> createSubject(Subject subject) async {
    final response = await http.post(
      Uri.parse('$baseUrl/subjects'),
      headers: {'Content-Type': 'application/json'},
      body: subject.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create subject');
    }
  }

  Future<void> deleteSubject(Subject subject) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/subjects'),
      headers: {'Content-Type': 'application/json'},
      body: subject.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete subject');
    }
  }

  Future<void> updateSubject(Subject subject) async {
    final response = await http.put(
      Uri.parse('$baseUrl/subjects'),
      headers: {'Content-Type': 'application/json'},
      body: subject.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update subject');
    }
  }
}
