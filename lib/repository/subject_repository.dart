import 'package:untitled/entity/subject.dart';

abstract class SubjectRepository {
  Future<List<Subject>> getSubjects();
  Future<void> addSubject(Subject subject);
  Future<void> updateSubject(Subject subject);
  Future<void> deleteSubject(Subject subject);
}