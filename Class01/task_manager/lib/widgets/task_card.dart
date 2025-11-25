import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/task.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'package:intl/intl.dart';

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

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  String _formatDueDate(DateTime? date) {
    if (date == null) return 'No Due Date';
    return DateFormat('EEE, MMM d, h:mm a').format(date);
  }

  bool _isRepeating(Task t) {
    return t.repeat != null &&
        t.repeat!.isNotEmpty &&
        t.repeat != 'Does not repeat';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color surfaceColor = theme.colorScheme.surface;
    final Color textColor = theme.colorScheme.onSurface;
    final Color accentColor = theme.colorScheme.secondary;

    final subtasks = task.subtasks ?? [];
    double progress = 0.0;
    if (subtasks.isNotEmpty) {
      final completedCount = subtasks.where((s) => s.isCompleted).length;
      progress = completedCount / subtasks.length;
    } else if (task.isCompleted) {
      progress = 1.0;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              theme.brightness == Brightness.dark ? 0.3 : 0.1,
            ),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 8,
              decoration: BoxDecoration(
                color: _getPriorityColor(task.priority),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Chip(
                          label: Text(task.category),
                          backgroundColor: accentColor.withOpacity(0.12),
                          labelStyle: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDueDate(task.dueDate),
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: textColor.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              accentColor,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                icon: Icon(
                  task.isCompleted
                      ? Icons.check_circle
                      : Icons.check_box_outline_blank,
                  color: task.isCompleted
                      ? accentColor.withOpacity(0.4)
                      : accentColor,
                  size: 28,
                ),
                onPressed: () async {
                  final provider =
                  Provider.of<TaskProvider>(context, listen: false);
                  final wasCompleted = task.isCompleted;
                  await provider.toggleTaskCompletion(task);

                  if (_isRepeating(task) && !wasCompleted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Next occurrence scheduled.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else if (!wasCompleted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Task marked complete.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Task reopened.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}