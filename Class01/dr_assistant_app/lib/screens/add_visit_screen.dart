import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';
import '../database/database_helper.dart';
import '../models/visit_model.dart';

class AddVisitScreen extends StatefulWidget {
  final int patientId;
  const AddVisitScreen({super.key, required this.patientId});

  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for Visit Details
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _treatmentController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  File? _prescriptionImage;
  bool _isSaving = false;

  @override
  void dispose() {
    _diagnosisController.dispose();
    _treatmentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Visit Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: kPrimaryGreen, // Header background color
                onPrimary: Colors.white, // Header text color
                onSurface: Colors.black, // Body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: kPrimaryGreen), // Button color
              ),
            ),
            child: child!,
          );
        });
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Image Picker (Camera or Gallery)
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _prescriptionImage = File(pickedFile.path);
      });
    }
  }

  // Database mein Visit data save karne ka function
  Future<void> _saveVisit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      try {
        // Image path ko database mein save karna
        // Note: Real app mein aapko image ko permanent storage mein move karna hoga.
        String? imagePath = _prescriptionImage?.path;

        final newVisit = Visit(
          patientId: widget.patientId,
          date: DateFormat('yyyy-MM-dd').format(_selectedDate),
          diagnosis: _diagnosisController.text.trim(),
          treatment: _treatmentController.text.trim(),
          notes: _notesController.text.trim(),
          prescriptionImagePath: imagePath,
        );

        await DatabaseHelper.instance.insertVisit(newVisit);

        // Success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visit recorded successfully!')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to record visit: $e')),
        );
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // Reusable Input Card Widget
  Widget _buildInputCard({
    required String label,
    required TextEditingController controller,
    bool required = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: required ? '$label *' : label,
            border: InputBorder.none,
          ),
          validator: validator ?? (value) {
            if (required && (value == null || value.isEmpty)) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Visit'),
        backgroundColor: kPrimaryGreen,
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _saveVisit,
            icon: _isSaving
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
                : const Text('Save', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              // --- Visit Date Picker ---
              const Text('Visit Date', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: Icon(Icons.calendar_today, color: kPrimaryGreen),
                  title: Text(
                    DateFormat('EEEE, dd MMMM yyyy').format(_selectedDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: const Icon(Icons.arrow_drop_down),
                  onTap: () => _selectDate(context),
                ),
              ),
              const SizedBox(height: 20),

              // --- Diagnosis ---
              const Text('Diagnosis', style: TextStyle(fontWeight: FontWeight.bold)),
              _buildInputCard(
                label: 'Enter diagnosis',
                controller: _diagnosisController,
                required: true,
                maxLines: 2,
              ),

              // --- Treatment/Prescription ---
              const Text('Treatment / Prescription', style: TextStyle(fontWeight: FontWeight.bold)),
              _buildInputCard(
                label: 'Enter treatment details',
                controller: _treatmentController,
                required: false,
                maxLines: 3,
              ),

              // --- Notes ---
              const Text('Notes (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
              _buildInputCard(
                label: 'Add extra notes',
                controller: _notesController,
                required: false,
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // --- Prescription Image / Attachments ---
              const Text('Prescription Image', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _prescriptionImage == null
                          ? Center(
                        child: Column(
                          children: [
                            Icon(Icons.image, size: 50, color: kPrimaryGreen.shade300),
                            const Text('No image selected'),
                          ],
                        ),
                      )
                          : Image.file(_prescriptionImage!, height: 150, fit: BoxFit.cover),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Camera'),
                            style: TextButton.styleFrom(foregroundColor: kPrimaryGreen),
                          ),
                          TextButton.icon(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Gallery'),
                            style: TextButton.styleFrom(foregroundColor: kPrimaryGreen),
                          ),
                          if (_prescriptionImage != null)
                            IconButton(
                              onPressed: () => setState(() { _prescriptionImage = null; }),
                              icon: const Icon(Icons.delete_forever, color: Colors.red),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- Record Visit Button ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveVisit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : const Text('Record Visit', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}