import 'package:flutter/material.dart';
import '../main.dart';
import '../database/database_helper.dart';
import '../models/patient_model.dart';
import 'patient_details_screen.dart';
import 'add_patient_screen.dart';
import 'edit_patient_screen.dart'; // Ensure this is imported

class AllPatientsScreen extends StatefulWidget {
  const AllPatientsScreen({super.key});

  @override
  State<AllPatientsScreen> createState() => _AllPatientsScreenState();
}

class _AllPatientsScreenState extends State<AllPatientsScreen> {
  List<Patient> _patients = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  // Database se sabhi patients ko load/search karne ka function
  Future<void> _loadPatients([String? query]) async {
    setState(() {
      _isLoading = true;
    });

    List<Patient> results;
    if (query != null && query.isNotEmpty) {
      results = await DatabaseHelper.instance.searchPatients(query);
    } else {
      results = await DatabaseHelper.instance.getAllPatients();
    }

    setState(() {
      _patients = results;
      _isLoading = false;
    });
  }

  // Function to show confirmation dialog before deleting
  void _confirmDelete(Patient patient) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to permanently delete patient ${patient.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx); // Close dialog
              // Database se delete karein
              await DatabaseHelper.instance.deletePatient(patient.id!);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${patient.name} deleted successfully.')),
              );
              _loadPatients(_searchController.text); // List refresh karein
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Patient List Item Widget
  Widget _buildPatientCard(Patient patient) {
    String initials = patient.name.isNotEmpty ? patient.name.substring(0, 1).toUpperCase() : 'N/A';

    return Card(
      margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        // Patient details par tap karne par View open karein
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientDetailsScreen(patient: patient),
            ),
          );
          _loadPatients(_searchController.text);
        },
        leading: CircleAvatar(
          backgroundColor: kPrimaryGreen.shade100,
          child: Text(
            initials,
            style: TextStyle(color: kPrimaryGreen, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(patient.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(patient.phone),
            Text(patient.email.isNotEmpty ? patient.email : 'Email not provided', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        isThreeLine: true,

        // --- FIX: PopupMenuButton (Three-dot Menu) ---
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'view') {
              // View Patient Details
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientDetailsScreen(patient: patient),
                ),
              );
            } else if (value == 'edit') {
              // Edit Patient Screen
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPatientScreen(patient: patient),
                ),
              );
            } else if (value == 'delete') {
              // Show Delete Confirmation Dialog
              _confirmDelete(patient);
            }
            // Edit/Delete ke baad list refresh karne ke liye
            _loadPatients(_searchController.text);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility, color: Colors.blueGrey),
                  SizedBox(width: 8),
                  Text('View'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_forever, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
          icon: const Icon(Icons.more_vert),
        ),
        // --- END PopupMenuButton ---
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Patients'),
        backgroundColor: kPrimaryGreen,
        actions: [
          // Search Icon ki zaroorat nahi kyunke search bar mojood hai
        ],
      ),
      body: Column(
        children: [
          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search patients...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    _loadPatients(value);
                  },
                ),
              ),
            ),
          ),

          // --- Patients List ---
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: () => _loadPatients(_searchController.text),
              child: _patients.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 80,
                      color: kPrimaryGreen.shade300,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'No patients yet',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text('Add your first patient to get started'),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: _patients.length,
                itemBuilder: (context, index) {
                  return _buildPatientCard(_patients[index]);
                },
              ),
            ),
          ),
        ],
      ),

      // Floating Action Button to Add Patient
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryGreen,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPatientScreen()),
          );
          _loadPatients(_searchController.text);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}