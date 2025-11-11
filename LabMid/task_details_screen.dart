import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // REQUIRED for date formatting
import 'package:provider/provider.dart'; // FIX 1: Add Provider import
import '../theme.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../providers/task_provider.dart'; // FIX 2: Add TaskProvider import
import 'task_edit_sheet.dart'; // To open the edit modal
// FIX: Corrected the import path for the ExportFormatScreen
import 'export_flow/export_format_screen.dart'; // To open the export flow

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {

  double get _progress {
    final List<Subtask> subtasks = widget.task.subtasks ?? []; // Null check
    if (subtasks.isEmpty) return 0.0;
    int completedCount = subtasks.where((s) => s.isCompleted).length;
    return completedCount / subtasks.length;
  }

  // Helper to get priority color (repeated from TaskCard for self-containment)
  Color _getPriorityColor(String priority) {
    // NOTE: 'priorityHigh', 'priorityMedium', 'priorityLow' are assumed to be defined in '../theme.dart'
    switch (priority) {
      case 'High': return priorityHigh;
      case 'Medium': return priorityMedium;
      case 'Low': return priorityLow;
      default: return Colors.grey;
    }
  }

  // --- ✅ FIX: Subtask status update aur database save logic (copyWith use karte hue) ---
  void _toggleSubtaskStatus(Subtask subtask) {
    // 1. Local state update karein (for immediate visual feedback)
    setState(() {
      subtask.isCompleted = !subtask.isCompleted;
    });

    // 2. Subtask ki updated list taiyar karein
    final updatedSubtasks = widget.task.subtasks?.map((s) {
      // Find the subtask by title/ID and return the updated subtask
      if (s.title == subtask.title) {
        return subtask;
      }
      return s;
    }).toList();

    // 3. TaskProvider ke zariye Database mein change save karein
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    // ✅ FIX: Task object ko copyWith() se naye subtask list ke saath banayein.
    // 'subtasks' property final hai, isliye naya Task object banana zaroori hai.
    if (widget.task.id != null && updatedSubtasks != null) {
      final updatedTask = widget.task.copyWith(
        subtasks: updatedSubtasks,
        updatedAt: DateTime.now(), // Update time stamp
      );

      // Updated Task ko database mein save karein
      taskProvider.updateTask(updatedTask);
    }
    // Note: Agar TaskProvider mein updateTask ke baad notifyListeners() call ho raha hai,
    // to task list screens automatic refresh ho jayengi.
  }


  @override
  Widget build(BuildContext context) {
    // FIX 1: Theme colors ko context se lein
    final theme = Theme.of(context);
    final Color bgColor = theme.colorScheme.background;
    final Color textColor = theme.colorScheme.onBackground;
    final Color accentColor = theme.colorScheme.secondary;
    final Color appBarColor = theme.scaffoldBackgroundColor; // AppBar ka background color

    final priorityColor = _getPriorityColor(widget.task.priority);
    final List<Subtask> subtasks = widget.task.subtasks ?? []; // FIX: Real subtasks list

    return Scaffold(
      backgroundColor: bgColor, // FIX 2: Scaffold background color theme se
      body: Stack(
        children: [
          // --- Main Scrollable Content ---
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: appBarColor, // FIX 3: AppBar background color theme se
                iconTheme: IconThemeData(color: textColor), // FIX 4: Back button color color theme se
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  centerTitle: false,
                  title: Text(
                    widget.task.title,
                    style: TextStyle( // FIX 5: Title text color theme se
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                    decoration: BoxDecoration(
                      // Priority border color same rakha hai
                      border: Border(bottom: BorderSide(color: priorityColor, width: 3)),
                      color: appBarColor, // FIX 6: Background color theme se
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        // Display Due Date
                        Text(
                          widget.task.dueDate != null
                              ? 'Due: ${DateFormat('EEE, MMM d, h:mm a').format(widget.task.dueDate!)}'
                              : 'No Due Date',
                          style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 16), // FIX 7: Text color theme se
                        ),
                        // Display Repeat Info
                        if (widget.task.repeat != null && widget.task.repeat != 'Does not repeat')
                          Text(
                            'Repeats: ${widget.task.repeat}',
                            style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 16), // FIX 8: Text color theme se
                          ),
                        const SizedBox(height: 30),
                        // --- Progress Visualization (Circular + Percent) ---
                        _buildProgressWheel(priorityColor, textColor), // FIX 9: Text Color pass karein
                      ],
                    ),
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    // --- Task Description/Notes ---
                    _buildSectionHeader('Notes', accentColor), // FIX 10: Accent Color pass karein
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      child: Text(
                        widget.task.description ?? 'No detailed description available.',
                        style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 16), // FIX 11: Text color theme se
                      ),
                    ),

                    // --- Subtasks Section (Using real subtasks) ---
                    _buildSectionHeader('Progress: Subtasks (${subtasks.length})', accentColor), // FIX 12: Accent Color pass karein
                    if (subtasks.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                        child: Text(
                            "No subtasks have been added to this task.",
                            style: TextStyle(color: textColor.withOpacity(0.5)) // FIX 13: Text color theme se
                        ),
                      ),
                    // FIX 3: Mock list ki bajaye, real subtasks list use karein
                    ...subtasks.map((subtask) => _buildSubtaskTile(subtask, textColor, accentColor)).toList(), // FIX 14: Colors pass karein

                    // --- Activity Log (Using real timestamps) ---
                    _buildSectionHeader('Activity Log', accentColor), // FIX 15: Accent Color pass karein
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      // FIX 4: Hardcoded text ki bajaye, real createdAt aur updatedAt use karein
                      child: _buildActivityLogText(widget.task, textColor), // FIX 16: Text Color pass karein
                    ),
                    const SizedBox(height: 100), // Space for bottom bar
                  ],
                ),
              ),
            ],
          ),

          // --- Bottom Action Bar (Fixed) ---
          _buildBottomActionBar(context, textColor, accentColor, theme.colorScheme.surface), // FIX 17: Colors pass karein
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSubtaskTile(Subtask subtask, Color textColor, Color accentColor) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: GestureDetector(
        onTap: () {
          // FIX 5: Naye helper function ko call karein
          _toggleSubtaskStatus(subtask);
        },
        child: Icon(
          subtask.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: subtask.isCompleted ? accentColor : textColor.withOpacity(0.5), // FIX 18: Colors theme se
        ),
      ),
      title: Text(
        subtask.title,
        style: TextStyle( // FIX 19: Text color theme se
          color: textColor,
          decoration: subtask.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          decorationColor: textColor,
        ),
      ),
    );
  }

  // --- NEW: Activity Log Builder Function ---
  Widget _buildActivityLogText(Task task, Color textColor) {
    // Task created on: Date and Time
    final createdAtFormatted = DateFormat('dd MMM yyyy, h:mm a').format(task.createdAt);

    // Last modified time
    String modifiedText;
    if (task.updatedAt.difference(task.createdAt) < const Duration(seconds: 5)) {
      modifiedText = "Never modified.";
    } else if (task.updatedAt.day == DateTime.now().day) {
      modifiedText = "Last modified today at ${DateFormat('h:mm a').format(task.updatedAt)}.";
    } else {
      modifiedText = "Last modified on ${DateFormat('dd MMM yyyy').format(task.updatedAt)}.";
    }

    return Text(
      'Task created on $createdAtFormatted.\n$modifiedText',
      style: TextStyle(color: textColor.withOpacity(0.5)), // FIX 20: Text color theme se
    );
  }

  Widget _buildProgressWheel(Color color, Color textColor) {
    // FIX: Progress wheel ka size 80x80 se badal kar 100x100 kiya gaya
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: _progress),
            duration: const Duration(milliseconds: 700),
            builder: (context, value, child) {
              return CircularProgressIndicator(
                value: value,
                strokeWidth: 8, // FIX: StrokeWidth 8 se badal kar 10 kiya gaya
                backgroundColor: color.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              );
            },
          ),
          Text(
            '${(_progress * 100).toInt()}',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              // Font size ko default par chhora gaya hai, taake 100% theek se fit ho
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: accentColor, // FIX 22: Accent color theme se
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  // --- NEW FUNCTION: Confirmation Dialog for Delete ---
  void _showDeleteConfirmationDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text('Are you sure you want to permanently delete "${task.title}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text('DELETE', style: TextStyle(color: priorityHigh)),
              onPressed: () async {
                // Task ID check karein
                if (task.id != null) {
                  // 1. TaskProvider se delete function call karein
                  // NOTE: 'listen: false' is used because we are inside a button callback
                  await Provider.of<TaskProvider>(context, listen: false).deleteTask(task.id!);

                  // 2. Dialog band karein
                  Navigator.of(dialogContext).pop();

                  // 3. Detail screen se wapas (home screen ya list screen) jaayen
                  Navigator.of(context).pop();
                } else {
                  // Agar ID null hai to sirf dialog band karein
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
  // ---------------------------------------------------

  Widget _buildBottomActionBar(BuildContext context, Color textColor, Color accentColor, Color surfaceColor) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: surfaceColor, // FIX 23: Bottom bar color theme se
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Edit Button
            _buildActionButton(
              icon: Icons.edit_note,
              label: 'Edit',
              iconColor: accentColor, // FIX 24: Accent color theme se
              textColor: textColor, // FIX 25: Text color pass karein
              onTap: () {
                // Opens Task Add / Edit Sheet pre-filled with current task data
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent, // Modal sheet ko transparent rakhein
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => TaskEditSheet(taskToEdit: widget.task),
                );
              },
            ),

            // Share/Export Button
            _buildActionButton(
              icon: Icons.share,
              label: 'Share',
              iconColor: accentColor, // FIX 26: Accent color theme se
              textColor: textColor, // FIX 27: Text color pass karein
              onTap: () {
                // Opens Export Format Selection
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ExportFormatScreen()));
              },
            ),

            // Delete Button
            _buildActionButton(
              icon: Icons.delete_outline,
              label: 'Delete',
              iconColor: priorityHigh,
              textColor: textColor, // FIX 28: Text color pass karein
              onTap: () {
                // FIX: Ab confirmation dialog ko call karein
                _showDeleteConfirmationDialog(context, widget.task);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color textColor, // FIX 29: New required parameter
    Color iconColor = accentGreen,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 12)), // FIX 30: Text color theme se
          ],
        ),
      ),
    );
  }
}