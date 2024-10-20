import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/entity/subject.dart';
import 'package:untitled/repository/subject_repository.dart';

class SharedPrefsSubjectRepository extends SubjectRepository {
  static const _subjectsKey = 'subjects';

  final SharedPreferences _prefs;

  SharedPrefsSubjectRepository(this._prefs);

  @override
  Future<List<Subject>> getSubjects() async {
    final subjectsJson = _prefs.getStringList(_subjectsKey) ?? [];
    return subjectsJson.map(Subject.fromJson).toList();
  }

  @override
  Future<void> addSubject(Subject subject) async {
    final subjects = await getSubjects();
    subjects.add(subject);
    await _prefs.setStringList(_subjectsKey, subjects.map((s) => s.toJson())
        .toList(),);
  }

  @override
  Future<void> updateSubject(Subject subject) async {
    final subjects = await getSubjects();
    final index = subjects.indexWhere((s) => s.name == subject.name);
    if (index != -1) {
      subjects[index] = subject;
      await _prefs.setStringList(_subjectsKey, subjects.map((s) => s.toJson())
          .toList(),);
    }
  }

  @override
  Future<void> deleteSubject(Subject subject) async {
    final subjects = await getSubjects();
    subjects.removeWhere((s) => s.name == subject.name);
    await _prefs.setStringList(_subjectsKey, subjects.map((s) => s.toJson())
        .toList(),);
  }
}
