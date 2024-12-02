import 'package:labs/entity/subject.dart';
import 'package:labs/repository/api/api_user_repository.dart';
import 'package:labs/service/subject_service.dart';
import 'package:labs/service/user_service.dart';
import 'package:uuid/uuid.dart';

class SubjectManager {
  final SubjectService _subjectService;
  final UserService _userService;

  SubjectManager(this._subjectService, this._userService);

  static Future<SubjectManager> initialize() async {
    final userRepository = ApiUserRepository();
    final subjectService = SubjectService();
    final userService = UserService(userRepository);

    return SubjectManager(subjectService, userService);
  }

  Future<List<Subject>> getSubjects() async {
    final currentUser = await _userService.getCurrentUser();

    if (currentUser == null) {
      return [];
    }

    return _subjectService.getSubjects(currentUser.id);
  }

  Future<void> addSubject(String name, int totalLabs, int completedLabs) async {
    final currentUser = await _userService.getCurrentUser();

    if (currentUser == null) {
      return;
    }

    final subject = Subject(
      const Uuid().v4(),
      name,
      totalLabs,
      completedLabs,
      currentUser.id,
    );
    await _subjectService.addSubject(subject);
  }

  Future<void> incrementLabs(Subject subject,
      void Function() onComplete,) async {
    if (subject.completedLabs < subject.totalLabs) {
      final updatedSubject = Subject(
        subject.id,
        subject.name,
        subject.totalLabs,
        subject.completedLabs + 1,
        subject.userId,
      );
      await _subjectService.updateSubject(updatedSubject);
      onComplete();
    }
  }

  Future<void> decrementLabs(Subject subject,
      void Function() onComplete,) async {
    if (subject.completedLabs > 0) {
      final updatedSubject = Subject(
        subject.id,
        subject.name,
        subject.totalLabs,
        subject.completedLabs - 1,
        subject.userId,
      );
      await _subjectService.updateSubject(updatedSubject);
      onComplete();
    }
  }

  Future<void> removeSubject(Subject subject,
      void Function() onComplete,) async {
    await _subjectService.deleteSubject(subject);
    onComplete();
  }
}
