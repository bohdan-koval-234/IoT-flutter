import 'package:untitled/entity/subject.dart';
import 'package:untitled/repository/subject_repository.dart';

class SubjectService {
  final SubjectRepository _subjectRepository;

  SubjectService(this._subjectRepository);

  Future<List<Subject>> getSubjects() async {
    return await _subjectRepository.getSubjects();
  }

  Future<void> addSubject(Subject subject) async {
    await _subjectRepository.addSubject(subject);
  }

  Future<void> updateSubject(Subject subject) async {
    await _subjectRepository.updateSubject(subject);
  }
}
