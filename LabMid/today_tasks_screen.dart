import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'task_details_screen.dart';
import '../models/task.dart'; // Task model ko import karna zaroori hai filtering ke liye

// ✅ FIX 1: StatelessWidget se StatefulWidget mein convert kiya
class TodayTasksScreen extends StatefulWidget {
  const TodayTasksScreen({super.key});

  @override
  State<TodayTasksScreen> createState() => _TodayTasksScreenState();
}

class _TodayTasksScreenState extends State<TodayTasksScreen> {
  // ✅ NEW: Search State variables
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // ✅ NEW: Listener add kiya
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    // Har baar text change hone par state update hogi aur list filter hogi
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  @override
  void dispose() {
    // ✅ NEW: Cleanup
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // ✅ NEW: Filtering Logic
  List<Task> _getFilteredTasks(List<Task> allTasks) {
    // 1. Pehle sirf incomplete tasks lein (Today's task usually means active tasks)
    final incompleteTasks = allTasks.where((task) => !task.isCompleted).toList();

    // 2. Agar search query khaali hai, toh wahi list return karein
    if (_searchQuery.isEmpty) {
      // NOTE: Agar aap sirf aaj ki date waale tasks dikhana chahte hain, toh uski logic yahan aayegi.
      // Filhal, yeh saare incomplete tasks dikha raha hai (jaisa ki aapke pichle codes mein tha).
      return incompleteTasks;
    }

    // 3. Search query ke mutabiq filter karo
    return incompleteTasks.where((task) {
      final title = task.title.toLowerCase();
      final description = task.description?.toLowerCase() ?? '';

      // Filter applied on title and description
      return title.contains(_searchQuery) || description.contains(_searchQuery);
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    final Color textColor = theme.colorScheme.onBackground;
    final Color surfaceColor = theme.colorScheme.surface;
    final Color accentColor = theme.colorScheme.secondary;
    final Color buttonFgColor = theme.brightness == Brightness.dark ? primaryDark : textLight;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {

          // ✅ FIX 2: Filtered list ko yahan calculate karein
          final tasksToShow = _getFilteredTasks(taskProvider.tasks);

          return CustomScrollView(
            slivers: [
              // --- Header Section (Greeting, Search, Filters) ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Header with Greeting
                      Text(
                        'Good Morning, Haseeb!',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        DateFormat('EEEE, MMM d').format(DateTime.now()),
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ✅ FIX 3: Search Field ko update karein
                      TextField(
                        controller: _searchController, // Controller joda
                        decoration: InputDecoration(
                          hintText: 'Search your tasks...',
                          hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                          prefixIcon: Icon(Icons.search, color: textColor.withOpacity(0.7)),
                          // ✅ NEW: Clear button agar search query hai
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                            icon: Icon(Icons.clear, color: textColor.withOpacity(0.7)),
                            onPressed: () => _searchController.clear(),
                          )
                              : null,
                          filled: true,
                          fillColor: surfaceColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: textColor),
                        onTap: () {
                          // Note: Agar aap full screen search use nahi kar rahe toh yeh onTap zaroori nahi.
                        },
                        // onSubmitted ya onChanged ki zaroorat nahi, kyunki humne listener use kiya hai.
                      ),
                      const SizedBox(height: 20),

                      // Filter Chips (All, Work, Personal)
                      Row(
                        children: [
                          _buildFilterChip(context, taskProvider, 'All'),
                          _buildFilterChip(context, taskProvider, 'Work'),
                          _buildFilterChip(context, taskProvider, 'Personal'),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),

              // --- Task List Section ---
              tasksToShow.isEmpty
                  ? SliverFillRemaining(
                child: Center(
                  child: Text(
                    // ✅ NEW: Search result ke mutabiq message
                    _searchQuery.isNotEmpty
                        ? 'No tasks found for "${_searchController.text}"'
                        : 'No tasks for today! Add a new one.',
                    style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 16),
                  ),
                ),
              )
                  : SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    // ✅ FIX 4: tasksToShow list ko use karein
                    final task = tasksToShow[index];

                    // Implement Swipe Actions using Dismissible
                    return Dismissible(
                      key: ValueKey(task.id),
                      direction: DismissDirection.horizontal,

                      // Background for Right Swipe (Complete - Green)
                      background: _buildDismissibleBackground(
                          Icons.check_circle_outline,
                          Colors.green,
                          Alignment.centerLeft,
                          theme.brightness == Brightness.dark ? primaryDark : textLight
                      ),

                      // Secondary Background for Left Swipe (Delete - Red)
                      secondaryBackground: _buildDismissibleBackground(
                          Icons.delete_outline,
                          priorityHigh,
                          Alignment.centerRight,
                          theme.brightness == Brightness.dark ? primaryDark : textLight
                      ),

                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          // Right Swipe: Mark Complete
                          taskProvider.completeTask(task);
                          return false;
                        } else if (direction == DismissDirection.endToStart) {
                          // Left Swipe: Delete (Show confirmation dialog first)
                          return await _showDeleteConfirmation(context, taskProvider, task.id!);
                        }
                        return false;
                      },

                      child: GestureDetector(
                        onTap: () {
                          // Tapping card opens Task Details Screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => TaskDetailsScreen(task: task)
                              )
                          );
                        },
                        child: TaskCard(task: task),
                      ),
                    );
                  },
                  childCount: tasksToShow.length, // ✅ FIX 5: tasksToShow ki length use karein
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- Helper Widgets (No Change) ---

  Widget _buildFilterChip(BuildContext context, TaskProvider provider, String label) {
    final isSelected = provider.currentFilter == label;
    final theme = Theme.of(context);
    final Color textColor = theme.colorScheme.onBackground;
    final Color accentColor = theme.colorScheme.secondary;
    final Color surfaceColor = theme.colorScheme.surface;
    final Color buttonFgColor = theme.brightness == Brightness.dark ? primaryDark : textLight;


    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? buttonFgColor : textColor.withOpacity(0.8),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: isSelected ? accentColor : surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: isSelected ? accentColor : Colors.transparent),
        ),
        onPressed: () {
          provider.setFilter(label);
        },
      ),
    );
  }

  Widget _buildDismissibleBackground(IconData icon, Color color, Alignment alignment, Color iconFgColor) {
    return Container(
      alignment: alignment,
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(icon, color: iconFgColor, size: 30),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context, TaskProvider provider, int taskId) async {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.secondary;

    final bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: Text("Confirm Deletion", style: TextStyle(color: theme.colorScheme.onSurface)),
          content: Text("Are you sure you want to delete this task?", style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.8))),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel", style: TextStyle(color: accentColor)),
            ),
            TextButton(
              onPressed: () {
                provider.deleteTask(taskId);
                Navigator.of(context).pop(true);
              },
              child: const Text("Delete", style: TextStyle(color: priorityHigh)),
            ),
          ],
        );
      },
    ) ?? false;
    return confirm;
  }
}