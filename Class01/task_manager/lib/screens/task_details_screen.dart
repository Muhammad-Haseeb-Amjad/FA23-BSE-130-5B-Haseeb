import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../theme.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../providers/task_provider.dart';
import 'task_edit_sheet.dart';
import 'export_flow/export_format_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  double get _progress {
    final List<Subtask> subtasks = widget.task.subtasks ?? [];
    if (subtasks.isEmpty) return 0.0;
    final completedCount = subtasks.where((s) => s.isCompleted).length;
    return completedCount / subtasks.length;
  }

  bool get _isRepeating {
    final r = widget.task.repeat;
    return r != null && r.isNotEmpty && r != 'Does not repeat';
  }

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

  void _toggleSubtaskStatus(Subtask subtask) {
    setState(() {
      subtask.isCompleted = !subtask.isCompleted;
    });

    final updatedSubtasks = widget.task.subtasks?.map((s) {
      if (s.title == subtask.title) return subtask;
      return s;
    }).toList();

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    if (widget.task.id != null && updatedSubtasks != null) {
      final updatedTask = widget.task.copyWith(
        subtasks: updatedSubtasks,
        updatedAt: DateTime.now(),
      );
      taskProvider.updateTask(updatedTask);
    }
  }

  void _shareTask() async {
    final subtasks = widget.task.subtasks ?? [];
    final shareText = '''
📋 Task: ${widget.task.title}

${widget.task.description != null && widget.task.description!.isNotEmpty ? '📝 Description:\n${widget.task.description}\n\n' : ''}📅 Due Date: ${widget.task.dueDate != null ? DateFormat('MMM dd, yyyy').format(widget.task.dueDate!) : 'No due date'}
⏰ Time: ${widget.task.dueDate != null ? DateFormat('hh:mm a').format(widget.task.dueDate!) : 'Not set'}

📂 Category: ${widget.task.category}
⭐ Priority: ${widget.task.priority}
${_isRepeating ? '🔄 Repeats: ${widget.task.repeat}\n' : ''}${subtasks.isNotEmpty ? '\n✓ Subtasks (${subtasks.where((s) => s.isCompleted).length}/${subtasks.length} completed):\n${subtasks.map((s) => '  ${s.isCompleted ? '✓' : '○'} ${s.title}').join('\n')}\n' : ''}---
Shared from Task Manager App
'''.trim();

    await Share.share(
      shareText,
      subject: 'Task: ${widget.task.title}',
    );
  }

  Future<void> _handleCompleteToggle() async {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final wasCompleted = widget.task.isCompleted;
    await provider.toggleTaskCompletion(widget.task);

    if (!wasCompleted) {
      if (_isRepeating) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task completed. Next occurrence scheduled.'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context); // Rollover -> close details
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task marked complete.'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task reopened.'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.colorScheme.background;
    final textColor = theme.colorScheme.onBackground;
    final accentColor = theme.colorScheme.secondary;
    final appBarColor = theme.scaffoldBackgroundColor;

    final priorityColor = _getPriorityColor(widget.task.priority);
    final subtasks = widget.task.subtasks ?? [];

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: appBarColor,
                iconTheme: IconThemeData(color: textColor),
                expandedHeight: 250.0,
                pinned: true,
                actions: [
                  IconButton(
                    tooltip: widget.task.isCompleted
                        ? 'Reopen'
                        : _isRepeating
                        ? 'Complete & roll over'
                        : 'Mark complete',
                    icon: Icon(
                      widget.task.isCompleted
                          ? Icons.refresh
                          : Icons.check_circle_outline,
                      color: accentColor,
                    ),
                    onPressed: _handleCompleteToggle,
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  centerTitle: false,
                  title: Text(
                    widget.task.title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: priorityColor, width: 3),
                      ),
                      color: appBarColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          widget.task.dueDate != null
                              ? 'Due: ${DateFormat('EEE, MMM d, h:mm a').format(widget.task.dueDate!)}'
                              : 'No Due Date',
                          style: TextStyle(
                            color: textColor.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                        if (_isRepeating)
                          Text(
                            'Repeats: ${widget.task.repeat}',
                            style: TextStyle(
                              color: textColor.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                        const SizedBox(height: 30),
                        _buildProgressWheel(priorityColor, textColor),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildSectionHeader('Notes', accentColor),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: Text(
                      widget.task.description ??
                          'No detailed description available.',
                      style: TextStyle(
                        color: textColor.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  _buildSectionHeader(
                    'Progress: Subtasks (${subtasks.length})',
                    accentColor,
                  ),
                  if (subtasks.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        "No subtasks have been added to this task.",
                        style: TextStyle(color: textColor.withOpacity(0.5)),
                      ),
                    ),
                  ...subtasks
                      .map(
                        (subtask) => _buildSubtaskTile(
                      subtask,
                      textColor,
                      accentColor,
                    ),
                  )
                      .toList(),
                  _buildSectionHeader('Activity Log', accentColor),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8.0,
                    ),
                    child: _buildActivityLogText(widget.task, textColor),
                  ),
                  const SizedBox(height: 100),
                ]),
              ),
            ],
          ),
          _buildBottomActionBar(
            context,
            textColor,
            accentColor,
            theme.colorScheme.surface,
          ),
        ],
      ),
    );
  }

  Widget _buildSubtaskTile(
      Subtask subtask,
      Color textColor,
      Color accentColor,
      ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: GestureDetector(
        onTap: () => _toggleSubtaskStatus(subtask),
        child: Icon(
          subtask.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color:
          subtask.isCompleted ? accentColor : textColor.withOpacity(0.5),
        ),
      ),
      title: Text(
        subtask.title,
        style: TextStyle(
          color: textColor,
          decoration:
          subtask.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          decorationColor: textColor,
        ),
      ),
    );
  }

  Widget _buildActivityLogText(Task task, Color textColor) {
    final createdAtFormatted =
    DateFormat('dd MMM yyyy, h:mm a').format(task.createdAt);

    String modifiedText;
    if (task.updatedAt.difference(task.createdAt) < const Duration(seconds: 5)) {
      modifiedText = "Never modified.";
    } else if (task.updatedAt.day == DateTime.now().day &&
        task.updatedAt.month == DateTime.now().month &&
        task.updatedAt.year == DateTime.now().year) {
      modifiedText =
      "Last modified today at ${DateFormat('h:mm a').format(task.updatedAt)}.";
    } else {
      modifiedText =
      "Last modified on ${DateFormat('dd MMM yyyy').format(task.updatedAt)}.";
    }

    return Text(
      'Task created on $createdAtFormatted.\n$modifiedText',
      style: TextStyle(color: textColor.withOpacity(0.5)),
    );
  }

  Widget _buildProgressWheel(Color color, Color textColor) {
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
                strokeWidth: 8,
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
          color: accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text(
            'Are you sure you want to permanently delete "${task.title}"?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text('DELETE', style: TextStyle(color: priorityHigh)),
              onPressed: () async {
                if (task.id != null) {
                  await Provider.of<TaskProvider>(
                    context,
                    listen: false,
                  ).deleteTask(task.id!);
                  Navigator.of(dialogContext).pop();
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomActionBar(
      BuildContext context,
      Color textColor,
      Color accentColor,
      Color surfaceColor,
      ) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: surfaceColor,
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
            _buildActionButton(
              icon: widget.task.isCompleted
                  ? Icons.refresh
                  : Icons.check_circle_outline,
              label: widget.task.isCompleted
                  ? 'Reopen'
                  : _isRepeating
                  ? 'Complete'
                  : 'Complete',
              iconColor: widget.task.isCompleted
                  ? accentColor
                  : accentColor,
              textColor: textColor,
              onTap: _handleCompleteToggle,
            ),
            _buildActionButton(
              icon: Icons.edit_note,
              label: 'Edit',
              iconColor: accentColor,
              textColor: textColor,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => TaskEditSheet(taskToEdit: widget.task),
                );
              },
            ),
            _buildActionButton(
              icon: Icons.share,
              label: 'Share',
              iconColor: accentColor,
              textColor: textColor,
              onTap: _shareTask,
            ),
            _buildActionButton(
              icon: Icons.delete_outline,
              label: 'Delete',
              iconColor: priorityHigh,
              textColor: textColor,
              onTap: () => _showDeleteConfirmationDialog(context, widget.task),
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
    required Color textColor,
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
            Text(
              label,
              style: TextStyle(
                color: textColor.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}