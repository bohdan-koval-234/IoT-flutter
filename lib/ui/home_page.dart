import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/entity/subject.dart';
import 'package:untitled/repository/shared/prefs/shared_prefs_subject_repository.dart';
import 'package:untitled/service/subject_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _subjectController = TextEditingController();
  final _totalLabsController = TextEditingController();
  final _completedLabsController = TextEditingController();
  SharedPrefsSubjectRepository? _subjectRepository;
  SubjectService? _subjectService;

  List<Subject> _subjects = [];


  Future<void> _initializeServices() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _subjectRepository = SharedPrefsSubjectRepository(prefs);
    _subjectService = SubjectService(_subjectRepository!);
  }

  Future<void> _initializeAndLoadSubjects() async {
    await _initializeServices();
    await _loadSubjects();
  }

  @override
  void initState() {
    super.initState();
    _initializeAndLoadSubjects();
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
            _buildProgressOverview(),
            const SizedBox(height: 16),
            _buildAddSubjectForm(),
            Expanded(
              child: ListView.builder(
                itemCount: _subjects.length,
                itemBuilder: (context, index) =>
                    _buildSubjectCard(_subjects[index]),
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

  Widget _buildProgressOverview() {
    final totalLabs = _subjects
        .fold(0, (sum, subject) => sum + subject.totalLabs);
    final completedLabs = _subjects
        .fold(0, (sum, subject) => sum + subject.completedLabs);
    final pendingLabs = totalLabs - completedLabs;
    final double completionRate = totalLabs > 0 ? completedLabs
        / totalLabs : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Labs Progress',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: completionRate,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
        ),
        const SizedBox(height: 8),
        Text('Completed: $completedLabs Labs'),
        Text('Pending: $pendingLabs Labs'),
      ],
    );
  }

  Widget _buildAddSubjectForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _subjectController,
          decoration: const InputDecoration(labelText: 'Subject Name'),
        ),
        TextField(
          controller: _totalLabsController,
          decoration: const InputDecoration(labelText: 'Total Labs'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _completedLabsController,
          decoration: const InputDecoration(labelText: 'Completed Labs'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _addSubject,
          child: const Text('Add Subject'),
        ),
      ],
    );
  }

  Widget _buildSubjectCard(Subject subject) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: subject.totalLabs > 0 ? subject.completedLabs
                  / subject.totalLabs : 0,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            Text('Total Labs: ${subject.totalLabs}'),
            Text('Completed: ${subject.completedLabs} '
                '| Pending: ${subject.totalLabs - subject.completedLabs}'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _incrementCompletedLabs(subject),
                  child: const Text('Add Completed Lab'),
                ),
                ElevatedButton(
                  onPressed: () => _decrementCompletedLabs(subject),
                  child: const Text('Remove Completed Lab'),
                ),
                ElevatedButton(
                  onPressed: () => _removeSubject(subject),
                  child: const Text('Remove Subject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _clearSubjectForm() {
    _subjectController.clear();
    _totalLabsController.clear();
    _completedLabsController.clear();
  }

  Future<void> _loadSubjects() async {
    final subjects = await _subjectService!.getSubjects();
    setState(() {
      _subjects = subjects;
    });
  }

  Future<void> _addSubject() async {
    final name = _subjectController.text.trim();
    final totalLabs = int.tryParse(_totalLabsController.text.trim()) ?? 0;
    final completedLabs = int.tryParse(_completedLabsController.text.trim())
        ?? 0;

    if (name.isNotEmpty && totalLabs > 0) {
      final subject = Subject(name, totalLabs, completedLabs);
      await _subjectService!.addSubject(subject);
      _loadSubjects();
      _clearSubjectForm();
    }
  }

  Future<void> _incrementCompletedLabs(Subject subject) async {
    final updatedSubject = Subject(
      subject.name,
      subject.totalLabs,
      subject.completedLabs + 1,
    );
    await _subjectService!.updateSubject(updatedSubject);
    _loadSubjects();
  }

  Future<void> _decrementCompletedLabs(Subject subject) async {
    final updatedSubject = Subject(
      subject.name,
      subject.totalLabs,
      subject.completedLabs - 1,
    );
    await _subjectService!.updateSubject(updatedSubject);
    _loadSubjects();
  }

  Future<void> _removeSubject(Subject subject) async {
    await _subjectRepository!.deleteSubject(subject);
    _loadSubjects();
  }
}
