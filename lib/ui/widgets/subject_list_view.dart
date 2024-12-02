import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labs/entity/subject.dart';
import 'package:labs/ui/blocs/subjects/subject_bloc.dart';
import 'package:labs/ui/widgets/subject_card.dart';

class SubjectListView extends StatelessWidget {
  final List<Subject> subjects;

  const SubjectListView({required this.subjects, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: subjects.length,
      itemBuilder: (context, index) => SubjectCard(
        subject: subjects[index],
        incrementLabs: () => _incrementLabs(context, subjects[index]),
        decrementLabs: () => _decrementLabs(context, subjects[index]),
        removeSubject: () => _removeSubject(context, subjects[index]),
      ),
    );
  }

  void _incrementLabs(BuildContext context, Subject subject) {
    if (subject.completedLabs < subject.totalLabs) {
      final updatedSubject = subject.copyWith(
        completedLabs: subject.completedLabs + 1,
      );
      context.read<SubjectBloc>().add(UpdateSubject(updatedSubject));
    }
  }

  void _decrementLabs(BuildContext context, Subject subject) {
    if (subject.completedLabs > 0) {
      final updatedSubject = subject.copyWith(
        completedLabs: subject.completedLabs - 1,
      );
      context.read<SubjectBloc>().add(UpdateSubject(updatedSubject));
    }
  }

  void _removeSubject(BuildContext context, Subject subject) {
    context.read<SubjectBloc>().add(DeleteSubject(subject));
  }
}
