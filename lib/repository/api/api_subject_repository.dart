import 'package:labs/entity/subject.dart';
import 'package:labs/repository/subject_repository.dart';
import 'package:labs/service/api/subject_api_service.dart';

class ApiSubjectRepository extends SubjectRepository {
  final SubjectApiService subjectApiService;
  static final ApiSubjectRepository _instance = ApiSubjectRepository
      ._internal(SubjectApiService());

  factory ApiSubjectRepository() {
    return _instance;
  }

  ApiSubjectRepository._internal(this.subjectApiService);

  @override
  Future<List<Subject>> getSubjects(String userId) async {
    return await subjectApiService.getSubjectsByUserId(userId);
  }

  @override
  Future<void> addSubject(Subject subject) async {
    await subjectApiService.createSubject(subject);
  }

  @override
  Future<void> updateSubject(Subject subject) async {
    await subjectApiService.updateSubject(subject);
  }

  @override
  Future<void> deleteSubject(Subject subject) async {
    await subjectApiService.deleteSubject(subject);
  }
}
