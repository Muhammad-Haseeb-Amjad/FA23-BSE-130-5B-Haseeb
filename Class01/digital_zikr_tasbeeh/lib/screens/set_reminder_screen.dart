// lib/screens/set_reminder_screen.dart

import 'package:flutter/material.dart';
import '../main.dart'; // For kPrimaryGreen

class SetReminderScreen extends StatefulWidget {
  final String? initialTime;
  final String? initialDays;

  const SetReminderScreen({super.key, this.initialTime, this.initialDays});

  @override
  State<SetReminderScreen> createState() => _SetReminderScreenState();
}

class _SetReminderScreenState extends State<SetReminderScreen> {
  TimeOfDay? _selectedTime;
  final List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> _selectedDays = [];

  // Custom button style for day selection
  final ButtonStyle _dayButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black,
    backgroundColor: Colors.grey.shade200,
    shape: const CircleBorder(),
    padding: const EdgeInsets.all(12),
    elevation: 0,
  );

  @override
  void initState() {
    super.initState();
    if (widget.initialTime != null) {
      // Parse initial time string "HH:MM"
      final parts = widget.initialTime!.split(':');
      if (parts.length == 2) {
        _selectedTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    }
    if (widget.initialDays != null && widget.initialDays!.isNotEmpty) {
      _selectedDays.addAll(widget.initialDays!.split(','));
    }
  }

  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: kPrimaryGreen, // Set primary color for the picker
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (newTime != null) {
      setState(() {
        _selectedTime = newTime;
      });
    }
  }

  void _saveReminder() {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please set a reminder time.')));
      return;
    }

    // Format time as "HH:MM" (24-hour format for database storage)
    final timeString = '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
    final daysString = _selectedDays.join(',');

    // Return the result map to the calling screen (SaveZikarScreen)
    Navigator.pop(context, {
      'time': timeString,
      'days': daysString,
    });
  }

  @override
  Widget build(BuildContext context) {
    // Helper to format TimeOfDay for display
    String displayTime = _selectedTime?.format(context) ?? 'Select Time';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Reminder'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          // Save Button (Top Right, as per IMG-20251028-WA0039.jpg)
          TextButton(
            onPressed: _saveReminder,
            child: const Text('Save', style: TextStyle(color: kPrimaryGreen, fontSize: 18)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Selection
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.schedule, color: kPrimaryGreen),
                title: Text('Reminder Time: $displayTime', style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.edit),
                onTap: _selectTime,
              ),
            ),

            const SizedBox(height: 30),

            const Text('Repeat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),

            // Day Selection (Row of Circular Buttons)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _weekDays.map((day) {
                final isSelected = _selectedDays.contains(day);
                return ElevatedButton(
                  onPressed: () => _toggleDay(day),
                  style: isSelected
                      ? ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: kPrimaryGreen,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                    elevation: 2,
                  )
                      : _dayButtonStyle,
                  child: Text(day[0], style: const TextStyle(fontSize: 16)), // Show Mon, Tue... as M, T...
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // Delete Reminder Option
            TextButton.icon(
              onPressed: () {
                // Clear reminder and return
                Navigator.pop(context, {'time': null, 'days': null});
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text('Delete Reminder', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}