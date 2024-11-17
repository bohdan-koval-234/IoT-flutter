import 'package:labs/entity/subject.dart';
import 'package:labs/repository/api/api_subject_repository.dart';
import 'package:labs/repository/subject_repository.dart';

class SubjectService {
  static final SubjectService _instance = SubjectService._internal();

  late final SubjectRepository _subjectRepository;

  factory SubjectService() {
    return _instance;
  }

  SubjectService._internal();

  static Future<SubjectService> initialize() async {
    final subjectRepository = ApiSubjectRepository();

    _instance._subjectRepository = subjectRepository;

    return _instance;
  }

  Future<List<Subject>> getSubjects(String userId) async {
    return await _subjectRepository.getSubjects(userId);
  }

  Future<void> addSubject(Subject subject) async {
    await _subjectRepository.addSubject(subject);
  }

  Future<void> updateSubject(Subject subject) async {
    await _subjectRepository.updateSubject(subject);
  }

  Future<void> deleteSubject(Subject subject) async {
    await _subjectRepository.deleteSubject(subject);
  }
}
