import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'task_details_screen.dart';
import '../models/task.dart';
import 'settings_screen.dart';
import 'task_edit_sheet.dart';

class TodayTasksScreen extends StatefulWidget {
  const TodayTasksScreen({super.key});

  @override
  State<TodayTasksScreen> createState() => _TodayTasksScreenState();
}

class _TodayTasksScreenState extends State<TodayTasksScreen>
    with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  bool _wasPaused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchFocusNode.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _wasPaused) {
      _handleUnlockReminder();
      _wasPaused = false;
    } else if (state == AppLifecycleState.paused) {
      _wasPaused = true;
    }
  }

  List<Task> _getFilteredTasks(List<Task> allTasks) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final todaysTasks = allTasks.where((task) {
      if (task.isCompleted) return false;

      final dueDate = task.dueDate;
      if (dueDate == null) {
        // Tasks without a due date stay visible on Today view
        return true;
      }

      // Show anything due today or overdue; hide future occurrences (e.g., rolled repeating tasks)
      return dueDate.isBefore(todayEnd);
    }).toList();

    if (_searchQuery.isEmpty) {
      return todaysTasks;
    }

    return todaysTasks.where((task) {
      final title = task.title.toLowerCase();
      final description = task.description?.toLowerCase() ?? '';
      return title.contains(_searchQuery) || description.contains(_searchQuery);
    }).toList();
  }

  Future<void> _handleUnlockReminder() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    if (!taskProvider.todayUnlockRemindersEnabled) return;

    final pendingTasks = taskProvider.pendingTodayTasks;
    if (pendingTasks.isEmpty) return;

    await taskProvider.showTodayUnlockReminder(pendingTasks);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color textColor = theme.colorScheme.onBackground;
    final Color surfaceColor = theme.colorScheme.surface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final tasksToShow = _getFilteredTasks(taskProvider.tasks);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top + 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Today',
                            style: TextStyle(
                              color: textColor.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Settings',
                            icon: Icon(
                              Icons.settings_outlined,
                              color: theme.colorScheme.secondary,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SettingsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
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
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              decoration: InputDecoration(
                                hintText: 'Search your tasks...',
                                hintStyle: TextStyle(
                                  color: textColor.withOpacity(0.5),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: textColor.withOpacity(0.7),
                                ),
                                filled: true,
                                fillColor: surfaceColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(color: textColor),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            tooltip: 'Clear search',
                            icon: Icon(
                              Icons.close,
                              color: textColor.withOpacity(0.7),
                            ),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                              _searchFocusNode.unfocus();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Row(
                            children: [
                              _buildFilterChip(context, taskProvider, 'All'),
                              _buildFilterChip(context, taskProvider, 'Work'),
                              _buildFilterChip(context, taskProvider, 'Personal'),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            '${tasksToShow.length} today',
                            style: TextStyle(
                              color: textColor.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              tasksToShow.isEmpty
                  ? SliverFillRemaining(
                child: Center(
                  child: Text(
                    _searchQuery.isNotEmpty
                        ? 'No tasks found for "${_searchController.text}"'
                        : 'No tasks for today! Add a new one.',
                    style: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontSize: 16,
                    ),
                  ),
                ),
              )
                  : SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final task = tasksToShow[index];
                    return Dismissible(
                      key: ValueKey(task.id),
                      direction: DismissDirection.horizontal,
                      background: _buildDismissibleBackground(
                        Icons.check_circle_outline,
                        Colors.green,
                        Alignment.centerLeft,
                        theme.brightness == Brightness.dark
                            ? primaryDark
                            : textLight,
                      ),
                      secondaryBackground: _buildDismissibleBackground(
                        Icons.delete_outline,
                        priorityHigh,
                        Alignment.centerRight,
                        theme.brightness == Brightness.dark
                            ? primaryDark
                            : textLight,
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          // Use new toggle with repeat rollover
                          await taskProvider.toggleTaskCompletion(task);
                          final bool isRepeating = task.repeat != null &&
                              task.repeat!.isNotEmpty &&
                              task.repeat != 'Does not repeat';
                          if (isRepeating) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Task completed. Next occurrence scheduled.',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Task marked complete.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                          return false; // Keep card (it may move if date changed)
                        } else if (direction ==
                            DismissDirection.endToStart) {
                          return await _showDeleteConfirmation(
                            context,
                            taskProvider,
                            task.id!,
                          );
                        }
                        return false;
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  TaskDetailsScreen(task: task),
                            ),
                          );
                        },
                        child: TaskCard(task: task),
                      ),
                    );
                  },
                  childCount: tasksToShow.length,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final primaryBg = theme.scaffoldBackgroundColor;

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: primaryBg,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const TaskEditSheet(),
          ).then((_) {
            Provider.of<TaskProvider>(context, listen: false).fetchTasks();
          });
        },
        backgroundColor: theme.colorScheme.secondary,
        child: Icon(
          Icons.add,
          color: theme.scaffoldBackgroundColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildFilterChip(
      BuildContext context,
      TaskProvider provider,
      String label,
      ) {
    final isSelected = provider.currentFilter == label;
    final theme = Theme.of(context);
    final Color textColor = theme.colorScheme.onBackground;
    final Color accentColor = theme.colorScheme.secondary;
    final Color surfaceColor = theme.colorScheme.surface;
    final Color buttonFgColor =
    theme.brightness == Brightness.dark ? primaryDark : textLight;

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
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? accentColor : Colors.transparent,
          ),
        ),
        onPressed: () {
          provider.setFilter(label);
        },
      ),
    );
  }

  Widget _buildDismissibleBackground(
      IconData icon,
      Color color,
      Alignment alignment,
      Color iconFgColor,
      ) {
    return Container(
      alignment: alignment,
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(icon, color: iconFgColor, size: 30),
    );
  }

  Future<bool> _showDeleteConfirmation(
      BuildContext context,
      TaskProvider provider,
      int taskId,
      ) async {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.secondary;

    final bool confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: Text(
            "Confirm Deletion",
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
          content: Text(
            "Are you sure you want to delete this task?",
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
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
              child: const Text(
                "Delete",
                style: TextStyle(color: priorityHigh),
              ),
            ),
          ],
        );
      },
    ) ??
        false;
    return confirm;
  }
}