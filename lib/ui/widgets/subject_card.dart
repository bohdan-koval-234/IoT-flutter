import 'package:flutter/material.dart';
import 'package:labs/entity/subject.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback incrementLabs;
  final VoidCallback decrementLabs;
  final VoidCallback removeSubject;

  const SubjectCard({
    required this.subject,
    required this.incrementLabs,
    required this.decrementLabs,
    required this.removeSubject,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(subject.name),
        subtitle: Text(
          'Completed: ${subject.completedLabs} / ${subject.totalLabs}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: incrementLabs,
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: decrementLabs,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: removeSubject,
            ),
          ],
        ),
      ),
    );
  }
}
