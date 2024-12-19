import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'models/task.dart';
import 'package:provider/provider.dart';
import 'taskcounters.dart';

class TaskListScreen extends StatefulWidget {
  final String category;
  final bool showCompleted;

  const TaskListScreen({
    super.key,
    required this.category,
    required this.showCompleted,
  });

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Box<Task> _taskBox;

  @override
  void initState() {
    super.initState();
    _taskBox = Hive.box<Task>('tasks');
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.showCompleted
        ? _taskBox.values.where((task) => task.isCompleted).toList()
        : _taskBox.values
            .where(
                (task) => task.category == widget.category && !task.isCompleted)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 81, 107, 255),
        elevation: 5,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  task.name, // Ensure task name is visible
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(221, 0, 0, 0),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.description, // Ensure task description is visible
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Deadline: ${task.deadline}", // Ensure task deadline is visible
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
                trailing: widget.showCompleted
                    ? IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          task.delete();

                          // No need to update counters for already completed tasks
                          setState(() {});
                        },
                      )
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            task.isCompleted = true;
                            task.completedDate = DateTime.now();
                            task.save();

                            // Update counters dynamically
                            final counters = Provider.of<TaskCounters>(context,
                                listen: false);
                            counters.incrementCompleted();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          'Mark as Completed',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
