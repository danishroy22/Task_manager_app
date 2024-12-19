import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart'; // For donut chart
import 'package:intl/intl.dart'; // For date formatting
import 'models/task.dart';
import 'taskcounters.dart'; // Import TaskCounters
import 'dart:math'; // For percentage calculation
import 'task_list_screen.dart';

class TaskManagerHomePage extends StatelessWidget {
  const TaskManagerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background for the entire page
      appBar: AppBar(
        title:
            const Text('Task Manager', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer<TaskCounters>(
        builder: (context, taskCounters, child) {
          return ValueListenableBuilder<Box<Task>>(
            valueListenable: Hive.box<Task>('tasks').listenable(),
            builder: (context, box, _) {
              final tasks = box.values.toList();

              // Update the counters based on task completion
              final completedTasks = tasks.where((t) => t.isCompleted).length;
              final workTasks = tasks
                  .where((t) => t.category == 'Work' && !t.isCompleted)
                  .length;
              final personalTasks = tasks
                  .where((t) => t.category == 'Personal' && !t.isCompleted)
                  .length;
              final urgentTasks = tasks
                  .where((t) => t.category == 'Urgent' && !t.isCompleted)
                  .length;

              // Update counters for categories
              taskCounters.updateTaskCounts(
                completed: completedTasks,
                work: workTasks,
                personal: personalTasks,
                urgent: urgentTasks,
              );

              // Calculate today's tasks
              final today = DateTime.now();
              final todayTasks = tasks
                  .where((t) => isSameDay(t.deadline, today) && !t.isCompleted)
                  .toList();
              final missedTasks = tasks
                  .where((t) => t.deadline.isBefore(today) && !t.isCompleted)
                  .toList();

              // Calculate percentage of completed tasks using TaskCounters
              final totalTasks = taskCounters.totalTasks;
              final percentageCompleted = totalTasks > 0
                  ? (taskCounters.completed / totalTasks) * 100
                  : 0;

              return Column(
                children: [
                  // Donut Chart with Today's Info
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Donut Chart
                        Expanded(
                          flex: 3,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                PieChart(
                                  PieChartData(
                                    sections: [
                                      if (completedTasks > 0)
                                        _buildChartSection("Completed",
                                            completedTasks, Colors.green),
                                      if (workTasks > 0)
                                        _buildChartSection(
                                            "Work", workTasks, Colors.blue),
                                      if (personalTasks > 0)
                                        _buildChartSection("Personal",
                                            personalTasks, Colors.orange),
                                      if (urgentTasks > 0)
                                        _buildChartSection(
                                            "Urgent", urgentTasks, Colors.red),
                                    ],
                                    sectionsSpace: 4,
                                    centerSpaceRadius: 50, // Thinner donut
                                    borderData: FlBorderData(show: true),
                                  ),
                                ),
                                Text(
                                  "${percentageCompleted.toStringAsFixed(1)}%",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 0, 255, 64),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Today's Info
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                DateFormat('d MMM').format(today),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                todayTasks.isEmpty
                                    ? "No tasks due today"
                                    : "${todayTasks.length} tasks Due today",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(
                                  height:
                                      8), // Add some spacing between the texts
                              Text(
                                missedTasks.isEmpty
                                    ? "No missed tasks"
                                    : "${missedTasks.length} missed tasks",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: Colors.red, // Set the color to red
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Task Grid
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.all(16),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildCategoryTile(
                            context, "Completed", taskCounters.completed),
                        _buildCategoryTile(context, "Work", taskCounters.work),
                        _buildCategoryTile(
                            context, "Personal", taskCounters.personal),
                        _buildCategoryTile(
                            context, "Urgent", taskCounters.urgent),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/addTask'),
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent, // Make the FAB more prominent
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, String title, int count) {
    return InkWell(
      onTap: () {
        if (title == "Completed") {
          // Open the CompletedTaskList screen when the "Completed" category is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CompletedTaskList(
                completedTasks: Hive.box<Task>('tasks')
                    .values
                    .where((task) => task.isCompleted)
                    .toList(), // Pass the list of completed tasks
              ),
            ),
          );
        } else {
          // For other categories, navigate to TaskListScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskListScreen(
                category: title,
                showCompleted: false,
              ),
            ),
          );
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 6, // More elevation for a better card effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent, // Blue Accent for category titles
              ),
            ),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PieChartSectionData _buildChartSection(String title, int value, Color color) {
    final total = max(1, value); // Avoid division by zero
    final percentage = (value / total * 100)
        .toStringAsFixed(0); // Percentage of completed tasks
    return PieChartSectionData(
      color: color,
      value: total.toDouble(),
      title:
          percentage == "100" ? "$value" : "$percentage%", // Display percentage
      titleStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      radius: 30,
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.day == date2.day && date1.month == date2.month;
  }
}

class CompletedTaskList extends StatelessWidget {
  final List<Task> completedTasks;

  const CompletedTaskList({super.key, required this.completedTasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Completed Tasks"),
        backgroundColor: Colors.blueAccent, // Consistent with FAB color
      ),
      body: ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          final task = completedTasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(task.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.description,
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    "Completed on: ${task.completedDate}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Delete task logic (if needed)
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
