import 'package:hive/hive.dart';

part 'task.g.dart'; // Hive requires this for generated code

@HiveType(typeId: 0) // Assign a unique ID to this model
class Task {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description; // Ensure this is defined

  @HiveField(2)
  String category;

  @HiveField(3)
  int seriousness; // 1: Low, 2: Medium, 3: High

  @HiveField(4)
  DateTime deadline;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  DateTime? completedDate; // New field

  Task({
    required this.name,
    required this.description,
    required this.category,
    required this.seriousness,
    required this.deadline,
    this.isCompleted = false,
    this.completedDate,
  });

  void save() {}

  void delete() {}
}
