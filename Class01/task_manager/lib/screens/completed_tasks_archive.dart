// lib/screens/completed_tasks_archive.dart (Updated ArchivedTaskTile.build)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class CompletedTasksArchive extends StatelessWidget {
  const CompletedTasksArchive({super.key});

  // ... (CompletedTasksArchive class remains the same)
  @override
  Widget build(BuildContext context) {
    // FIX 1: Theme ko context se lein
    final theme = Theme.of(context);
    final Color textColor = theme.colorScheme.onBackground;

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor, // FIX 2: Background color theme se
      appBar: AppBar(
        title: Text(
          'Completed & Archived Tasks',
          style: TextStyle(color: textColor),
        ), // FIX 3: Text color theme se
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          // FIX: taskProvider.tasks ko taskProvider.completedTasks se badla gaya.
          // Isse TaskProvider se seedhe complete hue tasks milenge.
          final completedTasks = taskProvider.completedTasks;

          if (completedTasks.isEmpty) {
            return Center(
              child: Text(
                'You haven\'t completed any tasks yet!\nKeep up the hard work!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor.withOpacity(0.6),
                  fontSize: 18,
                ), // FIX 4: Text color theme se
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: completedTasks.length,
            itemBuilder: (context, index) {
              final task = completedTasks[index];
              return ArchivedTaskTile(task: task);
            },
          );
        },
      ),
    );
  }
}

// --- Custom Widget for an Archived Task Tile ---
class ArchivedTaskTile extends StatelessWidget {
  final Task task;

  const ArchivedTaskTile({super.key, required this.task});

  // Helper to get priority color
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return priorityHigh;
      case 'Medium':
        return priorityMedium;
      case 'Low':
        return priorityLow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // FIX 5: Theme ko context se lein
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    final Color surfaceColor = theme.colorScheme.surface; // Card background
    final Color textColor = theme.colorScheme.onSurface; // Text color
    final Color accentColor = theme.colorScheme.secondary;
    final Color primaryBgColor =
        theme.colorScheme.background; // Used for icon in swipe

    return Dismissible(
      key: ValueKey(task.id),
      direction:
          DismissDirection.endToStart, // Only swipe left to delete permanently
      background: Container(
        alignment: Alignment.centerRight,
        color: priorityHigh, // Red for permanent delete
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          Icons.delete_forever_outlined,
          color: primaryBgColor,
          size: 30,
        ), // FIX 6: Icon color theme se (primaryDark ko primaryBgColor se replace kiya)
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Delete function is handled by the swipe confirmation dialog
          return await _showPermanentDeleteConfirmation(
            context,
            taskProvider,
            task,
          );
        }
        return false;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: surfaceColor, // FIX 7: Card surface color theme se
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: accentColor.withOpacity(0.5),
            width: 2,
          ), // FIX 8: Green border accent color theme se
        ),
        child: ListTile(
          leading: Icon(
            Icons.check_circle,
            color: accentColor,
            size: 30,
          ), // FIX 9: Icon color theme se
          title: Text(
            task.title,
            style: TextStyle(
              // FIX 10: Text color theme se
              color: textColor,
              decoration:
                  TextDecoration.lineThrough, // Strikethrough for completed
              decorationColor: textColor,
            ),
          ),
          subtitle: Text(
            // Show dueDate if available (which is set to today's date when completed),
            // otherwise fall back to updatedAt
            'Completed on: ${DateFormat('MMM d, yyyy').format(task.dueDate ?? task.updatedAt)}',
            style: TextStyle(
              color: textColor.withOpacity(0.7),
            ), // FIX 11: Text color theme se
          ),
          // --- FIX 12: Trailing ko Row se replace kiya taaki Restore aur Delete dono buttons aa jayen ---
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Restore Button
              IconButton(
                icon: const Icon(
                  Icons.undo_outlined,
                  color: priorityMedium,
                ), // priorityMedium is constant
                tooltip: 'Uncomplete Task',
                onPressed: () {
                  // Action to change task state back to incomplete
                  _uncompleteTask(taskProvider, task);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Task "${task.title}" restored!')),
                  );
                },
              ),
              // 2. Delete Button (NEW)
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: priorityHigh,
                ), // Red color for delete
                tooltip: 'Delete Permanently',
                onPressed: () async {
                  // Delete confirmation dialog ko call karein
                  final bool confirm = await _showPermanentDeleteConfirmation(
                    context,
                    taskProvider,
                    task,
                  );
                  if (confirm) {
                    // Agar confirmation mil jaaye toh snackbar dikha dein
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Task "${task.title}" deleted permanently!',
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Functions (No changes needed here) ---

  void _uncompleteTask(TaskProvider provider, Task task) {
    // FIX: Task.copyWith() ka istemaal karein taakay 'createdAt' aur 'updatedAt'
    // properties automatically copy ho jayen.
    final restoredTask = task.copyWith(
      isCompleted: false, // Set back to incomplete
      // Yahan updated_at ko bhi current time par set karna chahiye
      updatedAt: DateTime.now(),
    );

    // In a real app, you would call:
    // FIX: Provider ke through update karein
    provider.updateTask(restoredTask);

    // Note: Agar aapka provider update hone par UI refresh nahi karta,
    // toh aapko shayad fetchTasks() dobara call karna pade.
    // provider.fetchTasks();
  }

  Future<bool> _showPermanentDeleteConfirmation(
    BuildContext context,
    TaskProvider provider,
    Task task,
  ) async {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.secondary;

    final bool confirm =
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: theme
                  .colorScheme
                  .surface, // FIX 12: Dialog background theme se
              title: const Text(
                "Permanent Deletion",
                style: TextStyle(color: priorityHigh),
              ), // priorityHigh is constant
              content: Text(
                "Are you sure you want to permanently delete \"${task.title}\"?",
                style: TextStyle(color: theme.colorScheme.onSurface),
              ), // FIX 13: Content text theme se
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: accentColor),
                  ), // FIX 14: Cancel button theme se
                ),
                TextButton(
                  onPressed: () {
                    provider.deleteTask(
                      task.id!,
                    ); // Assuming ID is not null for completed tasks
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    "Delete Forever",
                    style: TextStyle(
                      color: priorityHigh,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // priorityHigh is constant
                ),
              ],
            );
          },
        ) ??
        false;
    return confirm;
  }
}
