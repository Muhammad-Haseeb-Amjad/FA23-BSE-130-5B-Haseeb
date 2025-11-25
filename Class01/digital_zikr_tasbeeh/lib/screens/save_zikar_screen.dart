// lib/screens/save_zikar_screen.dart

import 'package:flutter/material.dart';
import '../main.dart';
import '../models/zikar_model.dart';
import '../database/database_helper.dart';
import 'set_reminder_screen.dart'; // Reminder Screen

class SaveZikarScreen extends StatefulWidget {
  final ZikarModel? zikar; // Null if adding new, not null if editing

  const SaveZikarScreen({super.key, this.zikar});

  @override
  State<SaveZikarScreen> createState() => _SaveZikarScreenState();
}

class _SaveZikarScreenState extends State<SaveZikarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _arabicController = TextEditingController();
  final _targetController = TextEditingController();

  bool _setTarget = false;
  String? _reminderTime; // Saved reminder time
  String? _reminderDays; // Saved reminder days

  @override
  void initState() {
    super.initState();
    if (widget.zikar != null) {
      // Load data for editing
      _nameController.text = widget.zikar!.name;
      _arabicController.text = widget.zikar!.arabicText ?? '';
      if (widget.zikar!.targetCount != null) {
        _setTarget = true;
        _targetController.text = widget.zikar!.targetCount.toString();
      }
      _reminderTime = widget.zikar!.reminderTime;
      _reminderDays = widget.zikar!.reminderDays;
    }
  }

  Future<void> _saveZikar() async {
    if (_formKey.currentState!.validate()) {
      final int target = _setTarget ? (int.tryParse(_targetController.text) ?? 0) : 0;

      final ZikarModel newZikar = ZikarModel(
        id: widget.zikar?.id, // ID will be null for new zikar
        name: _nameController.text,
        arabicText: _arabicController.text.isNotEmpty ? _arabicController.text : null,
        count: widget.zikar?.count ?? 0, // Keep old count if editing, otherwise 0
        targetCount: _setTarget ? target : null,
        reminderTime: _reminderTime,
        reminderDays: _reminderDays,
      );

      if (newZikar.id == null) {
        // Insert New Zikar
        await DatabaseHelper.instance.insertZikar(newZikar);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Zikr saved successfully!')));
      } else {
        // Update Existing Zikar
        await DatabaseHelper.instance.updateZikar(newZikar);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Zikr updated successfully!')));
      }

      Navigator.pop(context); // Go back to Zikar List
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.zikar == null ? 'Add New Zikr' : 'Edit Zikr'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Zikr Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Zikr Name (e.g., SubhanAllah)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name for your Zikr';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Arabic Text (Optional)
              TextFormField(
                controller: _arabicController,
                textAlign: TextAlign.right, // Arabic text alignment
                decoration: const InputDecoration(labelText: 'Arabic Text (Optional)'),
              ),
              const SizedBox(height: 20),

              // Set Target Switch
              ListTile(
                title: const Text('Set Target Count'),
                trailing: Switch(
                  value: _setTarget,
                  activeColor: kPrimaryGreen,
                  onChanged: (val) {
                    setState(() {
                      _setTarget = val;
                    });
                  },
                ),
                contentPadding: EdgeInsets.zero,
              ),

              // Target Count Input
              if (_setTarget)
                TextFormField(
                  controller: _targetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Target Count (e.g., 100)'),
                  validator: (value) {
                    if (_setTarget && (value == null || int.tryParse(value) == null || int.parse(value) <= 0)) {
                      return 'Please enter a valid target count';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 20),

              // Set Reminder Button (Image: IMG-20251028-WA0036.jpg)
              ElevatedButton.icon(
                onPressed: () async {
                  // Open Set Reminder Screen and wait for results
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SetReminderScreen(
                        initialTime: _reminderTime,
                        initialDays: _reminderDays,
                      ),
                    ),
                  );

                  if (result != null && result is Map<String, String?>) {
                    setState(() {
                      _reminderTime = result['time'];
                      _reminderDays = result['days'];
                    });
                  }
                },
                icon: const Icon(Icons.alarm, color: Colors.white),
                label: Text(
                  _reminderTime == null ? 'Set Reminder' : 'Reminder: $_reminderTime',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentPurple,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
              const SizedBox(height: 30),

              // Final Save Button
              ElevatedButton(
                onPressed: _saveZikar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text(
                  'SAVE',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}