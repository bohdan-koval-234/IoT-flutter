import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labs/entity/subject.dart';
import 'package:labs/ui/blocs/auth/auth_bloc.dart';
import 'package:labs/ui/blocs/subjects/subject_bloc.dart';
import 'package:labs/ui/widgets/add_subject_form.dart';
import 'package:labs/ui/widgets/progress_overview.dart';
import 'package:labs/ui/widgets/subject_list_view.dart';
import 'package:uuid/uuid.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  HomeBodyState createState() => HomeBodyState();
}

class HomeBodyState extends State<HomeBody> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _totalLabsController = TextEditingController();
  final TextEditingController _completedLabsController =
  TextEditingController();
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        context.read<SubjectBloc>().add(LoadSubjects(authState.user.id));
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _totalLabsController.dispose();
    _completedLabsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectBloc, SubjectState>(
      builder: (context, state) {
        if (state is SubjectLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SubjectLoaded) {
          final subjects = state.subjects;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProgressOverview(subjects: subjects),
                const SizedBox(height: 16),
                AddSubjectForm(
                  subjectController: _subjectController,
                  totalLabsController: _totalLabsController,
                  completedLabsController: _completedLabsController,
                  addSubject: () => _addSubject(
                      context,
                      _subjectController,
                      _totalLabsController,
                      _completedLabsController,),
                ),
                const SizedBox(height: 16),
                Expanded(child: SubjectListView(subjects: subjects)),
              ],
            ),
          );
        } else if (state is SubjectError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('No subjects found'));
        }
      },
    );
  }

  void _addSubject(
      BuildContext context,
      TextEditingController subjectController,
      TextEditingController totalLabsController,
      TextEditingController completedLabsController,
      ) {
    final String name = subjectController.text.trim();
    final int totalLabs = int.tryParse(totalLabsController.text.trim()) ?? 0;
    final int completedLabs =
        int.tryParse(completedLabsController.text.trim()) ?? 0;

    if (name.isNotEmpty && totalLabs > 0) {
      final authState = context.read<AuthBloc>().state;
      String userId = '';
      if (authState is Authenticated) {
        userId = authState.user.id;
      }

      final subject = Subject(
        const Uuid().v4(),
        name,
        totalLabs,
        completedLabs,
        userId,
      );
      context.read<SubjectBloc>().add(AddSubject(subject));
      subjectController.clear();
      totalLabsController.clear();
      completedLabsController.clear();
    }
  }
}
