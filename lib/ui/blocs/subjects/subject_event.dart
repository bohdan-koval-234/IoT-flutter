part of 'subject_bloc.dart';

abstract class SubjectEvent extends Equatable {
  const SubjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadSubjects extends SubjectEvent {
  final String userId;

  const LoadSubjects(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddSubject extends SubjectEvent {
  final Subject subject;

  const AddSubject(this.subject);

  @override
  List<Object?> get props => [subject];
}

class UpdateSubject extends SubjectEvent {
  final Subject subject;

  const UpdateSubject(this.subject);

  @override
  List<Object?> get props => [subject];
}

class DeleteSubject extends SubjectEvent {
  final Subject subject;

  const DeleteSubject(this.subject);

  @override
  List<Object?> get props => [subject];
}
