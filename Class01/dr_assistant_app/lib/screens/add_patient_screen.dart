import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../main.dart';
import '../database/database_helper.dart';
import '../models/patient_model.dart';
// import 'edit_patient_screen.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for TextFields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedGender = 'Male';
  bool _isSaving = false;

  // Selected image ka path store karne ke liye
  File? _profileImage;

  // Gallery se image pick karne ke liye
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    // Gallery se image pick karein
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Reusable Input Card Widget (Wohi hai)
  Widget _buildInputCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            icon: Icon(icon, color: kPrimaryGreen),
            labelText: required ? '$label *' : label,
            hintText: hintText,
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

  // Database mein data save karne ka function
  Future<void> _savePatient() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      try {
        final newPatient = Patient(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          age: int.tryParse(_ageController.text.trim()) ?? 0,
          gender: _selectedGender,
          address: _addressController.text.trim(),
          notes: _notesController.text.trim(),
          // Note: Agar aap Patient model mein image path save karna chahte hain,
          // to model mein 'profileImagePath' field add karein aur yahan pass karein:
          // profileImagePath: _profileImage?.path,
        );

        await DatabaseHelper.instance.insertPatient(newPatient);

        // Success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient added successfully!')),
        );

        // ✅ FIX: 'true' return karein taake Dashboard refresh ho sake.
        Navigator.pop(context, true);

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add patient: $e')),
        );
        // Agar save fail ho, to 'false' ya 'null' return karein (lekin yahan pop karna zaroori nahi)
        // Navigator.pop(context, false);

      } finally {
        // Agar save fail ho jaye aur hum pop na karein to isko reset karna behtar hai
        if (Navigator.of(context).canPop() && _isSaving) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Patient'),
        backgroundColor: kPrimaryGreen,
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _savePatient,
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
            children: <Widget>[
              // --- Profile Picture Placeholder ---
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: kPrimaryGreen.shade100,
                    // Agar image select ho chuki hai to woh dikhayein
                    backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null
                        ? Icon(Icons.person, size: 50, color: kPrimaryGreen) // Agar image nahi hai to icon dikhayein
                        : null,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      onPressed: _pickImage, // _pickImage function call hoga
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Input Fields (Wohi hain) ---

              // Full Name
              _buildInputCard(
                icon: Icons.person,
                label: 'Full name',
                controller: _nameController,
                required: true,
              ),

              // Phone Number
              _buildInputCard(
                icon: Icons.phone,
                label: 'Phone number',
                controller: _phoneController,
                required: true,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  if (value.length < 10) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),

              // Email
              _buildInputCard(
                icon: Icons.email,
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              // Age and Gender (Side by Side)
              Row(
                children: [
                  // Age
                  Expanded(
                    child: _buildInputCard(
                      icon: Icons.cake,
                      label: 'Age',
                      controller: _ageController,
                      required: true,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Gender Dropdown
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: InputDecoration(
                            icon: Icon(Icons.transgender, color: kPrimaryGreen),
                            labelText: 'Gender *',
                            border: InputBorder.none,
                          ),
                          items: <String>['Male', 'Female', 'Other']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedGender = newValue!;
                            });
                          },
                          validator: (value) => value == null ? 'Required' : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Address
              _buildInputCard(
                icon: Icons.location_on,
                label: 'Address',
                controller: _addressController,
                required: true,
              ),

              // Notes
              _buildInputCard(
                icon: Icons.note,
                label: 'Notes',
                controller: _notesController,
                maxLines: 3,
              ),

              const SizedBox(height: 30),

              // Add Patient Button (Floating Action Button style jaisa)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _savePatient,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : const Text('Add Patient', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}