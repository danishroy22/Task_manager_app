import 'package:flutter/material.dart';

import 'models/task.dart'; // Make sure your Task model is imported correctly

class CompletedTaskList extends StatelessWidget {
  final List<Task> completedTasks;

  CompletedTaskList(this.completedTasks); // Only this one is needed
  @override
  Widget build(BuildContext context) {
    // Group tasks by completion date
    final Map<String, List<Task>> groupedTasks = {};
    for (var task in completedTasks) {
      final date =
          task.completedDate?.toLocal().toString().split(' ')[0] ?? "Unknown";
      if (!groupedTasks.containsKey(date)) {
        groupedTasks[date] = [];
      }
      groupedTasks[date]!.add(task);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Completed Tasks"),
      ),
      body: ListView(
        children: groupedTasks.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  entry.key,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...entry.value.map((task) {
                return ListTile(
                  title: Text(task.name),
                  subtitle:
                      Text('Deadline: ${task.deadline}\n${task.description}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Delete the task
                      _deleteTask(task);
                    },
                  ),
                );
              }),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _deleteTask(Task task) {
    task.delete(); // This deletes the task from the Hive box or database

    // If you're managing this data in a parent widget, you should update the list after deletion
    // Trigger a state change to update the UI
    // For example, using a callback or a provider to notify the parent widget
  }
}
