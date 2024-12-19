import 'package:flutter/material.dart';

class TaskDetailsScreen extends StatelessWidget {
  final String taskName;
  final String taskDescription;
  final String category;
  final int seriousness;
  final DateTime deadline;

  const TaskDetailsScreen({
    super.key,
    required this.taskName,
    required this.taskDescription,
    required this.category,
    required this.seriousness,
    required this.deadline,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(taskName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Category: $category",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Deadline: ${deadline.toLocal()}".split(' ')[0],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement task completion or deletion logic here
              },
              child: Text("Mark as Completed"),
            ),
          ],
        ),
      ),
    );
  }
}
