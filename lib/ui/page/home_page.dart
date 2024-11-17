import 'package:flutter/material.dart';
import 'package:labs/entity/subject.dart';
import 'package:labs/service/connectivity_service.dart';
import 'package:labs/ui/managers/subject_manager.dart';
import 'package:labs/ui/widgets/add_subject_form.dart';
import 'package:labs/ui/widgets/progress_overview.dart';
import 'package:labs/ui/widgets/subject_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final SubjectManager _subjectManager;
  late final ConnectivityService _connectivityService;

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _totalLabsController = TextEditingController();
  final TextEditingController _completedLabsController =
  TextEditingController();

  List<Subject> _subjects = [];

  @override
  void initState() {
    super.initState();
    _initializeAndLoad();
  }

  Future<void> _initializeAndLoad() async {
    await _initializeServices();
    await _loadSubjects();
  }

  Future<void> _initializeServices() async {
    _subjectManager = await SubjectManager.initialize();

    if (mounted) {
      _connectivityService = ConnectivityService(context);
    }
  }

  Future<void> _loadSubjects() async {
    final subjects = await _subjectManager.getSubjects();
    setState(() {
      _subjects = subjects;
    });
  }

  Future<void> _addSubject() async {
    final String name = _subjectController.text.trim();
    final int totalLabs = int.tryParse(_totalLabsController.text.trim()) ?? 0;
    final int completedLabs = int.tryParse(_completedLabsController
        .text.trim(),) ?? 0;

    if (name.isNotEmpty && totalLabs > 0) {
      await _subjectManager.addSubject(name, totalLabs, completedLabs);
      _loadSubjects();
      _clearSubjectForm();
    }
  }

  void _clearSubjectForm() {
    _subjectController.clear();
    _totalLabsController.clear();
    _completedLabsController.clear();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _totalLabsController.dispose();
    _completedLabsController.dispose();
    _connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProgressOverview(subjects: _subjects),
            const SizedBox(height: 16),
            AddSubjectForm(
              subjectController: _subjectController,
              totalLabsController: _totalLabsController,
              completedLabsController: _completedLabsController,
              addSubject: _addSubject,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _subjects.length,
                itemBuilder: (context, index) => SubjectCard(
                  subject: _subjects[index],
                  incrementLabs: () => _subjectManager
                      .incrementLabs(_subjects[index], _loadSubjects),
                  decrementLabs: () => _subjectManager
                      .decrementLabs(_subjects[index], _loadSubjects),
                  removeSubject: () => _subjectManager
                      .removeSubject(_subjects[index], _loadSubjects),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/profile'),
        child: const Icon(Icons.account_circle),
      ),
    );
  }
}
