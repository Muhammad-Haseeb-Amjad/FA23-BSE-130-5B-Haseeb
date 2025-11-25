import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../models/task.dart';
import '../screens/add_edit_task.dart';
import '../utils/notifications.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  const HomeScreen({super.key, required this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final db = DatabaseHelper();
  List<Task> tasks = [];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _refresh();
  }

  Future<void> _refresh() async {
    tasks = await db.getAllTasks();
    setState(() {});
  }

  List<Task> get todayTasks {
    final now = DateTime.now();
    return tasks.where((t) {
      if (t.dueDate == null || t.completed) return false;
      return t.dueDate!.year == now.year &&
          t.dueDate!.month == now.month &&
          t.dueDate!.day == now.day;
    }).toList();
  }

  List<Task> get completedTasks => tasks.where((t) => t.completed).toList();
  List<Task> get repeatedTasks => tasks.where((t) => t.repeat != 'none' && !t.completed).toList();

  Future<void> _addOrEditTask([Task? task]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditTask(task: task)),
    );
    await _refresh();
  }

  Future<void> _toggleComplete(Task t) async {
    t.completed = !t.completed;
    await db.updateTask(t);
    if (t.completed && t.notificationId != null) {
      await NotificationService().cancel(t.notificationId!);
    }
    await _refresh();
  }

  Future<void> _delete(Task t) async {
    if (t.notificationId != null) await NotificationService().cancel(t.notificationId!);
    await db.deleteTask(t.id!);
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Today"),
            Tab(text: "Completed"),
            Tab(text: "Repeated"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(todayTasks),
          _buildTaskList(completedTasks),
          _buildTaskList(repeatedTasks),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditTask(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(List<Task> list) {
    if (list.isEmpty) return const Center(child: Text("No tasks found"));
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (_, i) {
          final task = list[i];
          return TaskTile(
            task: task,
            onComplete: () => _toggleComplete(task),
            onEdit: () => _addOrEditTask(task),
            onDelete: () => _delete(task),
          );
        },
      ),
    );
  }
}
