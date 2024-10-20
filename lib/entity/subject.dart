import 'dart:convert';

class Subject {
  final String name;
  final int totalLabs;
  int completedLabs;

  Subject(this.name, this.totalLabs, this.completedLabs);

  String toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'name': name,
      'totalLabs': totalLabs,
      'completedLabs': completedLabs,
    };
    return jsonEncode(data);
  }

  static Subject fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json) as Map<String, dynamic>;
    return Subject(
      data['name'] as String,
      data['totalLabs'] as int,
      data['completedLabs'] as int,
    );
  }
}
