import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../models/task.dart';
import '../utils/notifications.dart';

class AddEditTask extends StatefulWidget {
  final Task? task;
  const AddEditTask({super.key, this.task});

  @override
  State<AddEditTask> createState() => _AddEditTaskState();
}

class _AddEditTaskState extends State<AddEditTask> {
  final _formKey = GlobalKey<FormState>();
  final db = DatabaseHelper();

  String title = '';
  String description = '';
  DateTime? dueDate;
  String repeat = 'none';
  List<int> repeatDays = [];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      title = widget.task!.title;
      description = widget.task!.description;
      dueDate = widget.task!.dueDate;
      repeat = widget.task!.repeat ?? 'none';
      repeatDays = widget.task!.repeatWeekdays ?? [];
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    setState(() {
      dueDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final task = Task(
      id: widget.task?.id,
      title: title,
      description: description,
      dueDate: dueDate,
      repeat: repeat,
      repeatWeekdays: repeatDays,
    );

    if (task.id == null) {
      final id = await db.insertTask(task);
      if (task.dueDate != null) {
        await NotificationService()
            .scheduleNotification(id, 'Task: ${task.title}', task.description, task.dueDate!);
      }
    } else {
      await db.updateTask(task);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? "Add Task" : "Edit Task")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.trim().isEmpty ? "Required" : null,
                onSaved: (v) => title = v!.trim(),
              ),
              TextFormField(
                initialValue: description,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (v) => description = v ?? '',
              ),
              ListTile(
                title: Text(
                  dueDate == null
                      ? "Select due date"
                      : DateFormat.yMd().add_jm().format(dueDate!),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: _pickDateTime,
                ),
              ),
              DropdownButtonFormField<String>(
                value: repeat,
                decoration: const InputDecoration(labelText: "Repeat"),
                items: const [
                  DropdownMenuItem(value: "none", child: Text("None")),
                  DropdownMenuItem(value: "daily", child: Text("Daily")),
                  DropdownMenuItem(value: "weekly", child: Text("Weekly")),
                ],
                onChanged: (v) => setState(() => repeat = v!),
              ),
              if (repeat == 'weekly')
                Wrap(
                  spacing: 5,
                  children: List.generate(7, (i) {
                    final d = i + 1;
                    final label = DateFormat.E().format(DateTime(2020, 1, d + 3));
                    final selected = repeatDays.contains(d);
                    return ChoiceChip(
                      label: Text(label),
                      selected: selected,
                      onSelected: (sel) {
                        setState(() {
                          if (sel) {
                            repeatDays.add(d);
                          } else {
                            repeatDays.remove(d);
                          }
                        });
                      },
                    );
                  }),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveTask,
                child: const Text("Save Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
