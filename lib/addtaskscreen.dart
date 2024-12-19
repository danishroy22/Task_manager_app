import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'models/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _taskName = '';
  String _taskDescription = '';
  String _category = 'Work';
  int _seriousness = 1;
  DateTime _deadline = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Task Name"),
                onSaved: (value) => _taskName = value!,
                validator: (value) =>
                    value!.isEmpty ? "Enter a task name" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Task Description"),
                onSaved: (value) => _taskDescription = value!,
                validator: (value) =>
                    value!.isEmpty ? "Enter a brief description" : null,
              ),
              DropdownButtonFormField<String>(
                value: _category,
                items: ["Work", "Personal", "Urgent"]
                    .map((category) => DropdownMenuItem(
                        value: category, child: Text(category)))
                    .toList(),
                onChanged: (value) => setState(() => _category = value!),
                decoration: InputDecoration(labelText: "Category"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Deadline: ${_deadline.toLocal()}".split(' ')[0]),
                  ElevatedButton(
                    onPressed: () async {
                      // Select the date
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _deadline,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        // Select the time
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_deadline),
                        );

                        if (pickedTime != null) {
                          // Combine the date and time
                          DateTime combinedDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );

                          setState(() => _deadline = combinedDateTime);
                        }
                      }
                    },
                    child: Text("Pick Date and Time"),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Save task to Hive
                    var taskBox = Hive.box<Task>('tasks');
                    taskBox.add(Task(
                      name: _taskName,
                      description: _taskDescription,
                      category: _category,
                      seriousness: _seriousness,
                      deadline: _deadline,
                    ));

                    Navigator.pop(context); // Return to the home screen
                  }
                },
                child: Text("Save Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
