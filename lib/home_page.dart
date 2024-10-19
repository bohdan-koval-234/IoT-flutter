import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<Subject> subjects = [];
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController totalLabsController = TextEditingController();
  final TextEditingController completedLabsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressOverview(),
            const SizedBox(height: 20),
            _buildAddSubjectForm(),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return _buildSubjectCard(subjects[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: _showAddSubjectDialog,
              tooltip: 'Add Subject',
              heroTag: 'Add Subject',
              child: const Icon(Icons.add),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child:
              Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    tooltip: 'Profile',
                    child: const Icon(Icons.account_circle),
                 ),
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressOverview() {
    final int totalLabs = subjects.fold(0, (sum, item) => sum + item.totalLabs);
    final int completedLabs = subjects
        .fold(0, (sum, item) => sum + item.completedLabs);
    final int pendingLabs = totalLabs - completedLabs;
    final double completionRate = totalLabs > 0 ? completedLabs / totalLabs : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Labs Progress',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: completionRate,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
        ),
        const SizedBox(height: 10),
        Text('Completed: $completedLabs Labs'),
        Text('Pending: $pendingLabs Labs'),
      ],
    );
  }

  Widget _buildAddSubjectForm() {
    return Column(
      children: [
        TextField(
          controller: subjectController,
          decoration: const InputDecoration(labelText: 'Subject Name'),
        ),
        TextField(
          controller: totalLabsController,
          decoration: const InputDecoration(labelText: 'Total Labs'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: completedLabsController,
          decoration: const InputDecoration(labelText: 'Completed Labs'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: subject.totalLabs > 0
                  ? subject.completedLabs / subject.totalLabs
                  : 0,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            const SizedBox(height: 10),
            Text('Total Labs: ${subject.totalLabs}'),
            Text('Completed: ${subject.completedLabs} '
                '| Pending: ${subject.totalLabs - subject.completedLabs}'),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addSubject() {
    final String name = subjectController.text;
    final int totalLabs = int.tryParse(totalLabsController.text) ?? 0;
    final int completedLabs = int.tryParse(completedLabsController.text) ?? 0;

    if (name.isNotEmpty && totalLabs > 0) {
      setState(() {
        subjects.add(Subject(name, totalLabs, completedLabs));
        subjectController.clear();
        totalLabsController.clear();
        completedLabsController.clear();
      });
    }
  }

  void _incrementCompletedLabs(Subject subject) {
    setState(() {
      if (subject.completedLabs < subject.totalLabs) {
        subject.completedLabs++;
      }
    });
  }

  void _decrementCompletedLabs(Subject subject) {
    setState(() {
      if (subject.completedLabs > 0) {
        subject.completedLabs--;
      }
    });
  }

  void _showAddSubjectDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Subject'),
          content: _buildAddSubjectForm(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class Subject {
  final String name;
  final int totalLabs;
  int completedLabs;

  Subject(this.name, this.totalLabs, this.completedLabs);
}
