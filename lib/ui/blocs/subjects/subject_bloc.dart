import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labs/entity/subject.dart';
import 'package:labs/service/subject_service.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final SubjectService subjectService;

  SubjectBloc(this.subjectService) : super(SubjectLoading()) {
    on<LoadSubjects>(_onLoadSubjects);
    on<AddSubject>(_onAddSubject);
    on<UpdateSubject>(_onUpdateSubject);
    on<DeleteSubject>(_onDeleteSubject);
  }

  Future<void> _onLoadSubjects(
      LoadSubjects event, Emitter<SubjectState> emit,) async {
    emit(SubjectLoading());
    try {
      final subjects = await subjectService.getSubjects(event.userId);
      emit(SubjectLoaded(subjects));
    } catch (e) {
      emit(const SubjectError('Failed to load subjects'));
    }
  }

  Future<void> _onAddSubject(
      AddSubject event, Emitter<SubjectState> emit,) async {
    if (state is SubjectLoaded) {
      try {
        await subjectService.addSubject(event.subject);
        final updatedSubjects = List<Subject>.from(
            (state as SubjectLoaded).subjects,)
          ..add(event.subject);
        emit(SubjectLoaded(updatedSubjects));
      } catch (e) {
        emit(const SubjectError('Failed to add subject'));
      }
    }
  }

  Future<void> _onUpdateSubject(
      UpdateSubject event, Emitter<SubjectState> emit,) async {
    if (state is SubjectLoaded) {
      try {
        await subjectService.updateSubject(event.subject);
        final updatedSubjects = (state as SubjectLoaded).subjects
            .map((s) => s.id == event.subject.id ? event.subject : s)
            .toList();
        emit(SubjectLoaded(updatedSubjects));
      } catch (e) {
        emit(const SubjectError('Failed to update subject'));
      }
    }
  }

  Future<void> _onDeleteSubject(
      DeleteSubject event, Emitter<SubjectState> emit,) async {
    if (state is SubjectLoaded) {
      try {
        await subjectService.deleteSubject(event.subject);
        final updatedSubjects = (state as SubjectLoaded)
            .subjects
            .where((s) => s.id != event.subject.id)
            .toList();
        emit(SubjectLoaded(updatedSubjects));
      } catch (e) {
        emit(const SubjectError('Failed to delete subject'));
      }
    }
  }
}

class ClearSubjects extends SubjectEvent {}
