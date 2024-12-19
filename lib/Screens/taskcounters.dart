import 'package:flutter/material.dart';

class TaskCounters with ChangeNotifier {
  int _completed = 0;
  int _work = 0;
  int _personal = 0;
  int _urgent = 0;

  int get completed => _completed;
  int get work => _work;
  int get personal => _personal;
  int get urgent => _urgent;

  int get totalTasks => _completed + _work + _personal + _urgent;

  void updateTaskCounts({
    required int completed,
    required int work,
    required int personal,
    required int urgent,
  }) {
    _completed = completed;
    _work = work;
    _personal = personal;
    _urgent = urgent;
    notifyListeners();
  }

  void incrementCompleted() {
    _completed++;
    notifyListeners();
  }

  void decrementCategoryCount(String category) {
    if (category == 'Work') {
      _work--;
    } else if (category == 'Personal') {
      _personal--;
    } else if (category == 'Urgent') {
      _urgent--;
    }
    notifyListeners();
  }
}
