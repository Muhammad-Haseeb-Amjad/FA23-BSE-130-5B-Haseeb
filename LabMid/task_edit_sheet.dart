// lib/screens/task_edit_sheet.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../database/database_helper.dart';
import '../providers/task_provider.dart';
// ✅ NEW IMPORT: ThemeProvider ko import karein taake defaults load kar saken
import '../providers/theme_provider.dart';
// ✅ NEW IMPORT: Notification Sound Picker Screen ke liye
import 'notification_sound_picker.dart';

// --- Global helper to style the priority selection (UNCHANGED) ---
class PriorityOption extends StatelessWidget {
// ... (Code Wahi Rahega) ...
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const PriorityOption({
    super.key,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // FIX 1: Theme ko context se lein
    final theme = Theme.of(context);
    final Color unselectedSurface = theme.colorScheme.surface; // Unselected chip background
    final Color selectedFgColor = theme.brightness == Brightness.dark ? primaryDark : textLight; // Selected chip text color (Dark Text on Colored BG)
    final Color unselectedFgColor = theme.colorScheme.onSurface; // Unselected chip text color

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.9) : unselectedSurface, // FIX 2: Surface color theme se
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? selectedFgColor : unselectedFgColor, // FIX 3: Text colors theme se
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


// --- The main modal sheet widget ---

class TaskEditSheet extends StatefulWidget {
  final Task? taskToEdit;

  const TaskEditSheet({
    super.key,
    this.taskToEdit,
  });

  @override
  State<TaskEditSheet> createState() => _TaskEditSheetState();
}

class _TaskEditSheetState extends State<TaskEditSheet> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat _dateFormat = DateFormat('EEEE, MMM d, h:mm a');
  final DateFormat _timeFormat = DateFormat('h:mm a'); // FIX: Time format ke liye

  // Input Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // State variables for dropdowns/chips
  String _selectedPriority = 'Medium';
  String _selectedRepeat = 'Does not repeat';
  List<String> _subtasks = [''];

  // Internal state for selected DateTime
  DateTime? _selectedDateTime;

  // FIX 1: Variable to store the original task's createdAt timestamp
  late DateTime _originalCreatedAt;

  // ✅ NEW NOTIFICATION STATE
  bool _getNotification = true;
  Duration _notificationTime = const Duration(minutes: 15); // e.g., 15 minutes before
  String _notificationSound = 'Default';
  // ------------------------------

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    // 💡 IMPORTANT: Provider ko initState mein direct access nahi kar sakte,
    // isliye humein isko Future.microtask mein wrap karna padega ya didChangeDependencies use karna padega.
    // Lekin simple code ke liye hum isko Future.microtask mein daal sakte hain.

    // Agar taskToEdit null nahi hai (Editing Mode)
    if (widget.taskToEdit != null) {
      final task = widget.taskToEdit!;
      _titleController.text = task.title;
      _descriptionController.text = task.description ?? '';
      _selectedPriority = task.priority;
      _selectedRepeat = task.repeat ?? 'Does not repeat';
      _originalCreatedAt = task.createdAt;

      if (task.dueDate != null) {
        _selectedDateTime = task.dueDate;
        _dateController.text = _dateFormat.format(task.dueDate!);
      }
      if (task.subtasks != null && task.subtasks!.isNotEmpty) {
        _subtasks = task.subtasks!.map((s) => s.title).toList();
      } else {
        _subtasks = [''];
      }

      // Load existing notification state
      _getNotification = task.isNotificationEnabled;
      _notificationTime = task.notificationTime ?? const Duration(minutes: 15);
      _notificationSound = task.notificationSound ?? 'default'; // Sound ko 'Default' se 'default' kiya for consistency

    } else {
      // Logic for NEW task
      // Set initial Due Date/Time (10:00 AM kal ka)
      _selectedDateTime = DateTime(now.year, now.month, now.day + 1, 10, 0);
      _dateController.text = _dateFormat.format(_selectedDateTime!);

      _originalCreatedAt = now;

      // ✅ FIX 4: Default notification settings ko ThemeProvider se load karein
      Future.microtask(() {
        if (!mounted) return;
        final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

        setState(() {
          _getNotification = themeProvider.defaultNotificationEnabled;
          // SharedPreferences se load ki hui value
          _notificationTime = Duration(minutes: themeProvider.defaultNotificationTimeMinutes);
          // SharedPreferences se load ki hui value
          _notificationSound = themeProvider.defaultNotificationSound;
        });
      });
      // ----------------------------------------------------
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // --- Helper Functions ---

  // Function to show Date/Time Picker
  void _selectDateTime() async {
// ... (Function code wahi rahega)
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      final initialTime = TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now().add(const Duration(hours: 1)));

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        // FIX 4: Corrected initialTime
        initialTime: initialTime,
      );
      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          _selectedDateTime = selectedDateTime;
          _dateController.text = _dateFormat.format(selectedDateTime);
        });
      }
    }
  }

  // ✅ NEW: Function to open Notification Sound Picker
  void _selectNotificationSound() async {
    final newSound = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationSoundPicker(initialSound: _notificationSound)),
    );
    if (newSound != null && mounted) {
      setState(() {
        _notificationSound = newSound;
      });
    }
  }
  // -------------------------------------------------

  // ✅ NEW: Function to select Notification Time (15 min, 30 min, 1 hour, etc.)
  void _selectNotificationTime(BuildContext context, Color textColor, Color accentColor) async {
    final Duration? selectedDuration = await showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Notification Time', style: TextStyle(color: textColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTimeOption(context, const Duration(minutes: 5), '5 minutes before', _notificationTime, textColor, accentColor),
              _buildTimeOption(context, const Duration(minutes: 15), '15 minutes before', _notificationTime, textColor, accentColor),
              _buildTimeOption(context, const Duration(minutes: 30), '30 minutes before', _notificationTime, textColor, accentColor),
              _buildTimeOption(context, const Duration(hours: 1), '1 hour before', _notificationTime, textColor, accentColor),
              _buildTimeOption(context, const Duration(hours: 24), '1 day before', _notificationTime, textColor, accentColor),
            ],
          ),
        );
      },
    );

    if (selectedDuration != null && mounted) {
      setState(() {
        _notificationTime = selectedDuration;
      });
    }
  }

  // ✅ NEW: Helper for Time Option Dialog
  Widget _buildTimeOption(BuildContext context, Duration value, String label, Duration currentValue, Color textColor, Color accentColor) {
    return ListTile(
      title: Text(label, style: TextStyle(color: textColor)),
      trailing: currentValue == value ? Icon(Icons.check, color: accentColor) : null,
      onTap: () {
        Navigator.pop(context, value);
      },
    );
  }
  // -----------------------------------------------------------------------------------


  // Function to handle saving the task
  void _saveTask() async {
// ... (Function code wahi rahega)
    if (_formKey.currentState!.validate()) {
      // Get TaskProvider instance
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      final now = DateTime.now();
      final isNewTask = widget.taskToEdit?.id == null;

      // Prepare Subtasks (Note: taskId will be 0 if new, or existing ID if editing)
      final List<Subtask> subtaskList = _subtasks
          .where((title) => title.trim().isNotEmpty)
          .map((title) => Subtask(
        taskId: widget.taskToEdit?.id ?? 0, // Temporary ID 0 for new tasks
        title: title,
        isCompleted: isNewTask ? false :
        widget.taskToEdit!.subtasks!.any((s) => s.title == title && s.isCompleted),
      ))
          .toList();

      // 1. Create/Update Task object
      final taskToSave = Task(
        id: widget.taskToEdit?.id,
        title: _titleController.text,
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        dueDate: _selectedDateTime,
        repeat: _selectedRepeat != 'Does not repeat' ? _selectedRepeat : null,
        priority: _selectedPriority,
        isCompleted: widget.taskToEdit?.isCompleted ?? false,
        subtasks: subtaskList,

        // ✅ NEW: Notification fields add kiye
        isNotificationEnabled: _getNotification,
        notificationTime: _notificationTime,
        notificationSound: _notificationSound,
        // ----------------------------------------

        // Use the original creation time saved in initState
        createdAt: _originalCreatedAt,
        updatedAt: now,
      );

      // 2. Save/Update to database
      if (isNewTask) {
        // FIX: Ab TaskProvider ka addTask use karein
        await taskProvider.addTask(taskToSave);
      } else {
        // Update existing task
        await taskProvider.updateTask(taskToSave); // updateTask already calls fetchTasks
      }

      // 3. Refresh data and close the modal
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  // --- UI Components ---

  // Generic Text Field Widget
  Widget _buildInputField({
// ... (Function code wahi rahega)
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    String? hintText,
  }) {
    // FIX 4: Theme ko context se lein
    final theme = Theme.of(context);
    final Color textColor = theme.colorScheme.onSurface;
    final Color inputFillColor = theme.colorScheme.surface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w600)), // FIX 5: Text color theme se
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: textColor), // FIX 6: Text color theme se
          decoration: InputDecoration(
            hintText: hintText ?? 'Enter task $label...',
            hintStyle: TextStyle(color: textColor.withOpacity(0.5)), // FIX 7: Hint color theme se
            // FIX 8: Input fill color theme se
            filled: true,
            fillColor: inputFillColor,
          ),
          validator: (value) {
            if (label == 'Title' && (value == null || value.isEmpty)) {
              return 'Title cannot be empty';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ✅ NEW: Function to display Duration as a readable string (e.g., 15 minutes before)
  String _durationToString(Duration duration) {
    if (duration == const Duration(minutes: 5)) return '5 minutes before';
    if (duration == const Duration(minutes: 15)) return '15 minutes before';
    if (duration == const Duration(minutes: 30)) return '30 minutes before';
    if (duration == const Duration(hours: 1)) return '1 hour before';
    if (duration == const Duration(hours: 24)) return '1 day before';
    return '15 minutes before'; // Default
  }
  // ------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
// ... (Widget tree code wahi rahega)
    // Determine if we are creating or editing
    final isEditing = widget.taskToEdit != null;

    // FIX 9: Theme ko context se lein
    final theme = Theme.of(context);
    final Color textColor = theme.colorScheme.onBackground;
    final Color dividerColor = theme.colorScheme.onBackground.withOpacity(0.1);
    final Color surfaceColor = theme.colorScheme.surface;
    final Color accentColor = theme.colorScheme.secondary;

    return Container( // FIX 10: Modal ke background ko theme se set karein
      color: theme.colorScheme.background,
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20, // Adjust for keyboard
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- Header/Close Button ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Task' : 'New Task',
                      style: TextStyle( // FIX 11: Text color theme se
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: textColor), // FIX 12: Icon color theme se
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(color: dividerColor, height: 30), // FIX 13: Divider color theme se

                // --- Title & Description ---
                _buildInputField(label: 'Title', controller: _titleController),
                _buildInputField(label: 'Description', controller: _descriptionController, maxLines: 3),

                // --- Due Date Picker ---
                Text('Due Date', style: TextStyle(color: textColor, fontWeight: FontWeight.w600)), // FIX 14: Text color theme se
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _selectDateTime,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.calendar_today, color: accentColor), // FIX 15: Icon color theme se
                        hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                        // FIX 16: Fill color theme se
                        filled: true,
                        fillColor: surfaceColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // --- Repeat Dropdown ---
                Text('Repeat', style: TextStyle(color: textColor, fontWeight: FontWeight.w600)), // FIX 17: Text color theme se
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedRepeat,
                  style: TextStyle(color: textColor), // FIX 18: Style text color theme se
                  dropdownColor: surfaceColor, // FIX 19: Dropdown background color theme se
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                    // FIX 20: Fill color theme se
                    filled: true,
                    fillColor: surfaceColor,
                  ),
                  items: <String>['Does not repeat', 'Daily', 'Weekly', 'Monthly', 'Custom']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: textColor)), // FIX 21: Dropdown item text color theme se
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // --- ✅ NEW: NOTIFICATION SETTINGS (Based on your image) ---
                if (_selectedDateTime != null) ...[
                  Divider(color: dividerColor, height: 30),
                  // 1. Get Notification Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Get notification', style: TextStyle(color: textColor, fontSize: 16)),
                      Switch(
                        value: _getNotification,
                        onChanged: (value) {
                          setState(() {
                            _getNotification = value;
                          });
                        },
                        activeColor: accentColor,
                      ),
                    ],
                  ),

                  // 2. Notification Time Setting (Only if enabled)
                  if (_getNotification)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Time', style: TextStyle(color: textColor, fontSize: 16)),
                      trailing: Text(_durationToString(_notificationTime), style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
                      onTap: () => _selectNotificationTime(context, textColor, accentColor),
                    ),

                  // 3. Notification Sound Setting (Only if enabled)
                  if (_getNotification)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Sound', style: TextStyle(color: textColor, fontSize: 16)),
                      trailing: Text(_notificationSound, style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
                      onTap: _selectNotificationSound,
                    ),
                  Divider(color: dividerColor, height: 30),
                ],
                // -------------------------------------------------------------------

                // --- Priority Selection ---
                Text('Priority', style: TextStyle(color: textColor, fontWeight: FontWeight.w600)), // FIX 22: Text color theme se
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PriorityOption(
                      label: 'Low',
                      color: priorityLow,
                      isSelected: _selectedPriority == 'Low',
                      onTap: () => setState(() => _selectedPriority = 'Low'),
                    ),
                    PriorityOption(
                      label: 'Medium',
                      color: priorityMedium,
                      isSelected: _selectedPriority == 'Medium',
                      onTap: () => setState(() => _selectedPriority = 'Medium'),
                    ),
                    PriorityOption(
                      label: 'High',
                      color: priorityHigh,
                      isSelected: _selectedPriority == 'High',
                      onTap: () => setState(() => _selectedPriority = 'High'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- Subtasks (Simplified Inline Addition) ---
                Text('Subtasks', style: TextStyle(color: textColor, fontWeight: FontWeight.w600)), // FIX 23: Text color theme se
                const SizedBox(height: 8),
                ..._subtasks.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.check_box_outline_blank, color: accentColor, size: 20), // FIX 24: Icon color theme se
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            initialValue: entry.value,
                            // FIX 6: Use onChanged to update the list value
                            onChanged: (value) => _subtasks[index] = value,
                            decoration: InputDecoration(
                              hintText: 'Add subtask...',
                              fillColor: surfaceColor, // FIX 25: Fill color theme se
                              contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            ),
                            style: TextStyle(color: textColor), // FIX 26: Text color theme se
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: textColor.withOpacity(0.6)), // FIX 27: Icon color theme se
                          onPressed: () {
                            setState(() {
                              _subtasks.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),

                // Add Subtask Button
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _subtasks.add('');
                    });
                  },
                  icon: Icon(Icons.add, color: accentColor), // FIX 28: Icon color theme se
                  label: Text('Add Subtask', style: TextStyle(color: accentColor)), // FIX 29: Text color theme se
                ),
                const SizedBox(height: 30),

                // --- Save Button ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveTask,
                    // ✅ NEW: Button text aapki image se match kiya
                    child: Text('Save Task'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}