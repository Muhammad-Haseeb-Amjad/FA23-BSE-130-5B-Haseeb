import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
// ✅ REMOVED: notification_sound_picker.dart import

class PriorityOption extends StatelessWidget {
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
    final theme = Theme.of(context);
    final Color unselectedSurface = theme.colorScheme.surface;
    final Color selectedFgColor = theme.brightness == Brightness.dark
        ? primaryDark
        : textLight;
    final Color unselectedFgColor = theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.9) : unselectedSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? selectedFgColor : unselectedFgColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class TaskEditSheet extends StatefulWidget {
  final Task? taskToEdit;

  const TaskEditSheet({super.key, this.taskToEdit});

  @override
  State<TaskEditSheet> createState() => _TaskEditSheetState();
}

class _TaskEditSheetState extends State<TaskEditSheet> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat _dateFormat = DateFormat('EEEE, MMM d, h:mm a');

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String _selectedPriority = 'Medium';
  String _selectedRepeat = 'Does not repeat';
  String _selectedCategory = 'Personal';
  List<String> _subtasks = [''];

  DateTime? _selectedDateTime;
  late DateTime _originalCreatedAt;

  // ✅ NOTIFICATION STATE (Sound option removed)
  bool _getNotification = true;
  Duration _notificationTime = const Duration(minutes: 15);
  // ✅ REMOVED: _notificationSoundValue
  TimeOfDay? _manualNotificationTime;
  bool _useManualNotificationTime = false;
  bool _manualSelectionTriggered = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    if (widget.taskToEdit != null) {
      final task = widget.taskToEdit!;
      _titleController.text = task.title;
      _descriptionController.text = task.description ?? '';
      _selectedPriority = task.priority;
      _selectedRepeat = task.repeat ?? 'Does not repeat';
      _selectedCategory = task.category;
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

      _getNotification = task.isNotificationEnabled;
      _notificationTime = task.notificationTime ?? const Duration(minutes: 15);
      // ✅ REMOVED: Loading notification sound

      if (_selectedDateTime != null && task.notificationTime != null) {
        const presetMinutes = {5, 15, 30, 60, 1440};
        if (!presetMinutes.contains(task.notificationTime!.inMinutes)) {
          final manualDateTime = _selectedDateTime!.subtract(
            task.notificationTime!,
          );
          _manualNotificationTime = TimeOfDay.fromDateTime(manualDateTime);
          _useManualNotificationTime = true;
        }
      }
    } else {
      _selectedDateTime = DateTime(now.year, now.month, now.day + 1, 10, 0);
      _dateController.text = _dateFormat.format(_selectedDateTime!);
      _originalCreatedAt = now;

      Future.microtask(() {
        if (!mounted) return;
        final themeProvider = Provider.of<ThemeProvider>(
          context,
          listen: false,
        );

        setState(() {
          _getNotification = themeProvider.defaultNotificationEnabled;
          _notificationTime = Duration(
            minutes: themeProvider.defaultNotificationTimeMinutes,
          );
          // ✅ REMOVED: Loading default sound
        });
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
      _selectedDateTime ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      final initialTime = TimeOfDay.fromDateTime(
        _selectedDateTime ?? DateTime.now().add(const Duration(hours: 1)),
      );

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
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

  // ✅ REMOVED: _selectNotificationSound() function

  void _selectNotificationTime(
      BuildContext context,
      Color textColor,
      Color accentColor,
      ) async {
    _manualSelectionTriggered = false;

    final Duration? selectedDuration = await showModalBottomSheet<Duration>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final viewInsets = MediaQuery.of(sheetContext).viewInsets;
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: viewInsets.bottom + 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: textColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select Notification Time',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTimeOption(
                    sheetContext,
                    const Duration(minutes: 5),
                    '5 minutes before',
                    _notificationTime,
                    textColor,
                    accentColor,
                  ),
                  _buildTimeOption(
                    sheetContext,
                    const Duration(minutes: 15),
                    '15 minutes before',
                    _notificationTime,
                    textColor,
                    accentColor,
                  ),
                  _buildTimeOption(
                    sheetContext,
                    const Duration(minutes: 30),
                    '30 minutes before',
                    _notificationTime,
                    textColor,
                    accentColor,
                  ),
                  _buildTimeOption(
                    sheetContext,
                    const Duration(hours: 1),
                    '1 hour before',
                    _notificationTime,
                    textColor,
                    accentColor,
                  ),
                  _buildTimeOption(
                    sheetContext,
                    const Duration(hours: 24),
                    '1 day before',
                    _notificationTime,
                    textColor,
                    accentColor,
                  ),
                  const Divider(),
                  ListTile(
                    title: Text('Custom…', style: TextStyle(color: textColor)),
                    subtitle: Text(
                      'Set your own reminder time',
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                    trailing: const Icon(Icons.edit),
                    onTap: () async {
                      final customDuration = await _showCustomDurationDialog(
                        sheetContext,
                        textColor,
                        accentColor,
                      );
                      if (customDuration != null) {
                        Navigator.of(sheetContext).pop(customDuration);
                      }
                    },
                  ),
                  ListTile(
                    title: Text('Manual time…', style: TextStyle(color: textColor)),
                    subtitle: Text(
                      'Pick an exact reminder time on the due date',
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                    trailing: const Icon(Icons.schedule),
                    onTap: () async {
                      final manualDuration = await _pickManualNotificationTime(
                        sheetContext,
                        textColor,
                        accentColor,
                      );
                      if (manualDuration != null) {
                        Navigator.of(sheetContext).pop(manualDuration);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (selectedDuration != null && mounted) {
      setState(() {
        _notificationTime = selectedDuration;
        if (_manualSelectionTriggered) {
          _useManualNotificationTime = true;
        } else {
          _useManualNotificationTime = false;
          _manualNotificationTime = null;
        }
        _manualSelectionTriggered = false;
      });
    }
  }

  Widget _buildTimeOption(
      BuildContext context,
      Duration value,
      String label,
      Duration currentValue,
      Color textColor,
      Color accentColor,
      ) {
    return ListTile(
      title: Text(label, style: TextStyle(color: textColor)),
      trailing: currentValue == value
          ? Icon(Icons.check, color: accentColor)
          : null,
      onTap: () {
        Navigator.pop(context, value);
      },
    );
  }

  Future<Duration?> _showCustomDurationDialog(
      BuildContext context,
      Color textColor,
      Color accentColor,
      ) async {
    final hoursController = TextEditingController(
      text: (_notificationTime.inHours >= 1)
          ? _notificationTime.inHours.toString()
          : '',
    );
    final minutesController = TextEditingController(
      text:
      (_notificationTime.inMinutes % 60 != 0 ||
          _notificationTime.inHours == 0)
          ? (_notificationTime.inMinutes % 60).toString()
          : '',
    );

    String? errorText;

    return showModalBottomSheet<Duration>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final viewInsets = MediaQuery.of(sheetContext).viewInsets;
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: viewInsets.bottom + 24,
            ),
            child: StatefulBuilder(
              builder: (context, setStateDialog) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: textColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Custom Notification Time',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: hoursController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Hours before',
                          labelStyle:
                          TextStyle(color: textColor.withOpacity(0.7)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: minutesController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Minutes before',
                          labelStyle:
                          TextStyle(color: textColor.withOpacity(0.7)),
                        ),
                      ),
                      if (errorText != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          errorText!,
                          style: TextStyle(color: priorityHigh, fontSize: 12),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () =>
                                  Navigator.of(sheetContext).pop(),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                              ),
                              onPressed: () {
                                final hours =
                                int.tryParse(hoursController.text.trim());
                                final minutes =
                                int.tryParse(minutesController.text.trim());

                                final totalHours = hours ?? 0;
                                final totalMinutes = minutes ?? 0;

                                if (totalHours < 0 || totalMinutes < 0) {
                                  setStateDialog(() {
                                    errorText = 'Values cannot be negative.';
                                  });
                                  return;
                                }

                                if (totalMinutes >= 60) {
                                  setStateDialog(() {
                                    errorText = 'Minutes must be less than 60.';
                                  });
                                  return;
                                }

                                if (totalHours == 0 && totalMinutes == 0) {
                                  setStateDialog(() {
                                    errorText =
                                    'Please provide a time greater than 0.';
                                  });
                                  return;
                                }

                                final duration = Duration(
                                  hours: totalHours,
                                  minutes: totalMinutes,
                                );
                                Navigator.of(sheetContext).pop(duration);
                              },
                              child: const Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      final now = DateTime.now();
      final isNewTask = widget.taskToEdit?.id == null;

      final List<Subtask> subtaskList = _subtasks
          .where((title) => title.trim().isNotEmpty)
          .map(
            (title) => Subtask(
          taskId: widget.taskToEdit?.id ?? 0,
          title: title,
          isCompleted: isNewTask
              ? false
              : widget.taskToEdit!.subtasks!.any(
                (s) => s.title == title && s.isCompleted,
          ),
        ),
      )
          .toList();

      final taskToSave = Task(
        id: widget.taskToEdit?.id,
        title: _titleController.text,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        dueDate: _selectedDateTime,
        repeat: _selectedRepeat != 'Does not repeat' ? _selectedRepeat : null,
        priority: _selectedPriority,
        isCompleted: widget.taskToEdit?.isCompleted ?? false,
        subtasks: subtaskList,

        // ✅ Notification fields (sound removed)
        isNotificationEnabled: _getNotification,
        notificationTime: _notificationTime,
        // ✅ REMOVED: notificationSound parameter
        category: _selectedCategory,

        createdAt: _originalCreatedAt,
        updatedAt: now,
      );

      if (isNewTask) {
        await taskProvider.addTask(taskToSave);
      } else {
        await taskProvider.updateTask(taskToSave);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    String? hintText,
  }) {
    final theme = Theme.of(context);
    final Color textColor = theme.colorScheme.onSurface;
    final Color inputFillColor = theme.colorScheme.surface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: hintText ?? 'Enter task $label...',
            hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
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

  String _durationToString(Duration duration) {
    if (duration == const Duration(minutes: 5)) return '5 minutes before';
    if (duration == const Duration(minutes: 15)) return '15 minutes before';
    if (duration == const Duration(minutes: 30)) return '30 minutes before';
    if (duration == const Duration(hours: 1)) return '1 hour before';
    if (duration == const Duration(hours: 24)) return '1 day before';

    if (duration.inMinutes == 0) return 'At due time';
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes} minutes before';
    }
    if (duration.inMinutes % 60 == 0 && duration.inHours < 24) {
      final hours = duration.inHours;
      return '$hours hour${hours > 1 ? 's' : ''} before';
    }
    if (duration.inMinutes % 1440 == 0) {
      final days = duration.inDays;
      return '$days day${days > 1 ? 's' : ''} before';
    }

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final parts = <String>[];
    if (hours > 0) {
      parts.add('$hours hour${hours > 1 ? 's' : ''}');
    }
    if (minutes > 0) {
      parts.add('$minutes minute${minutes > 1 ? 's' : ''}');
    }
    return '${parts.join(' ')} before';
  }

  // ✅ REMOVED: _normalizeSoundValue() and _resolveSoundLabel() functions

  Future<Duration?> _pickManualNotificationTime(
      BuildContext context,
      Color textColor,
      Color accentColor,
      ) async {
    if (_selectedDateTime == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Select a due date first.'),
            backgroundColor: accentColor,
          ),
        );
      }
      return null;
    }

    final initialTime =
        _manualNotificationTime ?? TimeOfDay.fromDateTime(_selectedDateTime!);
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime == null) {
      return null;
    }

    final manualDateTime = DateTime(
      _selectedDateTime!.year,
      _selectedDateTime!.month,
      _selectedDateTime!.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    final difference = _selectedDateTime!.difference(manualDateTime);

    if (difference <= Duration.zero) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Reminder time must be before the due time.'),
            backgroundColor: accentColor,
          ),
        );
      }
      return null;
    }

    _manualSelectionTriggered = true;

    if (mounted) {
      setState(() {
        _manualNotificationTime = pickedTime;
      });
    }

    return difference;
  }

  Widget _buildCategoryChip(String label, Color accentColor, Color textColor) {
    final bool isSelected = _selectedCategory == label;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color selectedLabelColor = isDark ? primaryDark : Colors.white;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedCategory = label;
        });
      },
      selectedColor: accentColor,
      labelStyle: TextStyle(color: isSelected ? selectedLabelColor : textColor),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskToEdit != null;
    final theme = Theme.of(context);
    final Color textColor = theme.colorScheme.onBackground;
    final Color dividerColor = theme.colorScheme.onBackground.withOpacity(0.1);
    final Color surfaceColor = theme.colorScheme.surface;
    final Color accentColor = theme.colorScheme.secondary;

    final topSafePadding = MediaQuery.of(context).viewPadding.top;

    return Container(
      color: theme.colorScheme.background,
      child: Padding(
        padding: EdgeInsets.only(
          top: 32 + (topSafePadding > 0 ? topSafePadding / 3 : 0),
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: textColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Task' : 'New Task',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Divider(color: dividerColor, height: 30),
                _buildInputField(label: 'Title', controller: _titleController),
                _buildInputField(
                  label: 'Description',
                  controller: _descriptionController,
                  maxLines: 3,
                ),

                Text(
                  'Category',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: [
                    _buildCategoryChip('Work', accentColor, textColor),
                    _buildCategoryChip('Personal', accentColor, textColor),
                  ],
                ),
                const SizedBox(height: 16),

                Text(
                  'Due Date',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _selectDateTime,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: accentColor,
                        ),
                        hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                        filled: true,
                        fillColor: surfaceColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Repeat',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedRepeat,
                  style: TextStyle(color: textColor),
                  dropdownColor: surfaceColor,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: surfaceColor,
                  ),
                  items:
                  <String>[
                    'Does not repeat',
                    'Daily',
                    'Weekly',
                    'Monthly',
                    'Custom',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: textColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // ✅ NOTIFICATION SETTINGS (Sound option removed)
                if (_selectedDateTime != null) ...[
                  Divider(color: dividerColor, height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Get notification',
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
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

                  if (_getNotification)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Time',
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
                      trailing: Text(
                        _useManualNotificationTime &&
                            _manualNotificationTime != null
                            ? 'Manual: ${_manualNotificationTime!.format(context)}'
                            : _durationToString(_notificationTime),
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => _selectNotificationTime(
                        context,
                        textColor,
                        accentColor,
                      ),
                    ),

                  // ✅ REMOVED: Sound ListTile
                  Divider(color: dividerColor, height: 30),
                ],

                Text(
                  'Priority',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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

                Text(
                  'Subtasks',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ..._subtasks.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_box_outline_blank,
                          color: accentColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            initialValue: entry.value,
                            onChanged: (value) => _subtasks[index] = value,
                            decoration: InputDecoration(
                              hintText: 'Add subtask...',
                              fillColor: surfaceColor,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                            ),
                            style: TextStyle(color: textColor),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: textColor.withOpacity(0.6),
                          ),
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

                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _subtasks.add('');
                    });
                  },
                  icon: Icon(Icons.add, color: accentColor),
                  label: Text(
                    'Add Subtask',
                    style: TextStyle(color: accentColor),
                  ),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveTask,
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