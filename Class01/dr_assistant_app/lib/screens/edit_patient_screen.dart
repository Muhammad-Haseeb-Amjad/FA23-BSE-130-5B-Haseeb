import 'package:flutter/material.dart';
import '../main.dart';
import '../database/database_helper.dart';
import '../models/patient_model.dart';
// import 'package:image_picker/image_picker.dart'; // Agar image editing bhi shamil karna ho

class EditPatientScreen extends StatefulWidget {
  final Patient patient;
  const EditPatientScreen({super.key, required this.patient});

  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for TextFields
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _addressController;
  late TextEditingController _notesController;

  late String _selectedGender;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Existing patient data ko controllers mein load karein
    _nameController = TextEditingController(text: widget.patient.name);
    _phoneController = TextEditingController(text: widget.patient.phone);
    _emailController = TextEditingController(text: widget.patient.email);
    _ageController = TextEditingController(text: widget.patient.age.toString());
    _addressController = TextEditingController(text: widget.patient.address);
    _notesController = TextEditingController(text: widget.patient.notes);
    _selectedGender = widget.patient.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Reusable Input Card Widget (Same as AddPatientScreen)
  Widget _buildInputCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    // FIX: Input Card widget mein koi 'const' issue nahi hai
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

  // Database mein data update karne ka function
  Future<void> _updatePatient() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      try {
        final updatedPatient = Patient(
          id: widget.patient.id, // ID zaruri hai update ke liye
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          age: int.tryParse(_ageController.text.trim()) ?? 0,
          gender: _selectedGender,
          address: _addressController.text.trim(),
          notes: _notesController.text.trim(),
        );

        await DatabaseHelper.instance.updatePatient(updatedPatient);

        // Success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${updatedPatient.name} updated successfully!')), // FIX: SnackBar ko const se remove kiya
        );
        Navigator.pop(context, true); // True return karein taake calling screen (AllPatientsScreen) refresh ho
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update patient: $e')),
        );
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Patient ke naam ka pehla harf (initial)
    String initials = widget.patient.name.isNotEmpty
        ? widget.patient.name.substring(0, 1).toUpperCase()
        : 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Patient'),
        backgroundColor: kPrimaryGreen,
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _updatePatient,
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
          // FIX: Column ko const se remove kiya, kyunke iske andar dynamic widgets hain
          child: Column(
            children: <Widget>[
              // --- Profile Picture Placeholder (Edit Patient Screen jaisa) ---
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 40,
                    // FIX: Shade100 property const nahi ho sakti, isliye CircleAvatar ko const se remove kiya
                    backgroundColor: kPrimaryGreen.shade100,
                    child: Text(
                      initials,
                      style: TextStyle(fontSize: 40, color: kPrimaryGreen, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Image update functionality TBD')),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Input Fields (Same as AddPatientScreen) ---

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
                  if (value == null || value.isEmpty) return 'Phone number is required';
                  if (value.length < 10) return 'Enter a valid phone number';
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
                        if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Invalid Age';
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
                              // DropdownMenuItem ko bhi const se remove kiya
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

              // Update Patient Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _updatePatient,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : const Text('Update Patient', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}