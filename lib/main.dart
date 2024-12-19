import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager2/task_calendar_screen.dart';

import 'addtaskscreen.dart';
import 'models/task.dart';
import 'settingssccreen.dart';
import 'taskcounters.dart';
import 'taskmanagerhomepage.dart'; // Assuming this is your homepage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');

  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  @override
  _TaskManagerAppState createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  int _selectedIndex = 0; // Track the current selected tab

  // List of screens corresponding to each tab
  static final List<Widget> _widgetOptions = <Widget>[
    const TaskManagerHomePage(),
    const TaskCalendarScreen(),
    const SettingsScreen(), // Add your SettingsScreen here
  ];

  // Method to update the selected tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Change the tab when tapped
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskCounters()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Scaffold(
                body: _widgetOptions
                    .elementAt(_selectedIndex), // Display the selected screen
                bottomNavigationBar: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today),
                      label: 'Task Calendar',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Settings',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped, // Change the selected tab when tapped
                ),
              ),
          '/addTask': (context) => const AddTaskScreen(),
          '/taskCalender': (context) => const TaskCalendarScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
