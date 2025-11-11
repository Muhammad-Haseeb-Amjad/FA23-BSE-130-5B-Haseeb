import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/task.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'package:intl/intl.dart'; // Import for Date Formatting

// Helper to get color based on priority string
Color _getPriorityColor(String priority) {
  // NOTE: 'priorityHigh', 'priorityMedium', 'priorityLow' are assumed to be defined in '../theme.dart'
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

  // Helper function to format DateTime
  String _formatDueDate(DateTime? date) {
    if (date == null) {
      return 'No Due Date';
    }
    // FIX: Format DateTime object into a readable String
    return DateFormat('EEE, MMM d, h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    // FIX 1: Theme colors ko context se lein
    final theme = Theme.of(context);
    final Color surfaceColor = theme.colorScheme.surface; // Card surface color
    final Color textColor = theme.colorScheme.onSurface;
    final Color accentColor = theme.colorScheme.secondary;

    // Mock progress (since we don't have subtask model yet)
    // We'll use a random value to mimic the look in the image.
    final double mockProgress = (task.id ?? 1) % 3 == 0 ? 0.75 : 0.25;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: surfaceColor, // FIX 2: Card surface color theme se
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            // Shadow color ko halka kiya ya theme se adjust kiya
            color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.3 : 0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // --- Priority Color Strip (Left) ---
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
                    // --- Title and Time ---
                    Text(
                      task.title,
                      style: TextStyle( // FIX 3: Text color theme se
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      // FIX: Call the helper function to format the DateTime object to String
                      _formatDueDate(task.dueDate),
                      style: TextStyle( // FIX 4: Text color theme se
                        color: textColor.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // --- Subtasks Progress Bar ---
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: mockProgress,
                            // FIX 5: Background color theme se
                            backgroundColor: textColor.withOpacity(0.1),
                            // FIX 6: Value color accent color se
                            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(mockProgress * 100).toInt()}%',
                          style: TextStyle(color: accentColor, fontSize: 12), // FIX 7: Text color accent se
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // --- Quick Actions (Right Checkbox) ---
            Container(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                icon: Icon(
                  Icons.check_box_outline_blank,
                  color: accentColor, // FIX 8: Icon color accent se
                  size: 28,
                ),
                onPressed: () {
                  // Quick Mark Complete action (uses bounce animation from spec)
                  // We'll just complete it instantly for simplicity.
                  Provider.of<TaskProvider>(context, listen: false).completeTask(task);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}