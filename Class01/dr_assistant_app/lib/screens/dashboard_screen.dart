import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../database/database_helper.dart';
import '../models/patient_model.dart';
import 'settings_screen.dart';
import 'add_patient_screen.dart';
import 'all_patients_screen.dart';
import 'patient_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Patient> _recentPatients = [];
  int _newPatientsCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  // Database se data load karne ka function
  // Yeh function loading state aur data state dono ko handle karta hai.
  Future<void> _loadDashboardData() async {
    // 1. Loading TRUE set karein
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    // 2. Data Fetch karein
    final count = await DatabaseHelper.instance.getNewPatientsCount(
        DateFormat('yyyy-MM-dd').format(DateTime.now()));

    final patients = await DatabaseHelper.instance.getRecentPatients(5);

    // 3. Data aur Loading FALSE set karein
    if (mounted) {
      setState(() {
        _newPatientsCount = count;
        _recentPatients = patients;
        _isLoading = false;
      });
    }
  }

  // Reusable card for Quick Actions
  Widget _buildQuickActionCard(
      {required IconData icon, required String title, required VoidCallback onTap, required Color color}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
        child: Container(
          width: 150, // Card width
          height: 120, // Card height
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable widget for Recent Patient List Item
  Widget _buildPatientCard(Patient patient) {
    String initials = patient.name.isNotEmpty ? patient.name.substring(0, 1).toUpperCase() : 'N/A';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: () async {
          // Patient Profile Screen par navigate karega
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientDetailsScreen(patient: patient),
            ),
          );
          // Wapas aane par data refresh karein (Yeh pehle se theek tha)
          _loadDashboardData();
        },
        leading: CircleAvatar(
          backgroundColor: kPrimaryGreen.shade100,
          child: Text(
            initials,
            style: TextStyle(color: kPrimaryGreen),
          ),
        ),
        title: Text(patient.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(patient.phone),
        trailing: const Icon(Icons.more_vert),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String todayDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Dr. Assistant', style: TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kPrimaryGreen.shade700!, kPrimaryGreen.shade400!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header Card (Good Morning!) ---
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      colors: [kPrimaryGreen.shade100, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Good Morning!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Today is $todayDate',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // --- Today's Overview ---
              const Text('Today\'s Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Icon(Icons.people_alt, size: 30, color: kPrimaryGreen),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _newPatientsCount.toString(),
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryGreen),
                          ),
                          const Text('New Patients', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // --- Quick Actions ---
              const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickActionCard(
                    icon: Icons.person_add_alt_1,
                    title: 'New Patient',
                    color: kPrimaryGreen.shade600!,
                    onTap: () async {
                      final shouldRefresh = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddPatientScreen()),
                      );
                      if (shouldRefresh == true) {
                        _loadDashboardData();
                      }
                    },
                  ),
                  _buildQuickActionCard(
                    icon: Icons.search,
                    title: 'Search',
                    color: Colors.orange.shade600,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllPatientsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: _buildQuickActionCard(
                  icon: Icons.list_alt,
                  title: 'All Patients',
                  color: Colors.blueGrey.shade600,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AllPatientsScreen()),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              // --- Recent Patients ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Patients', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AllPatientsScreen()),
                      );
                    },
                    child: Text('View All', style: TextStyle(color: kPrimaryGreen)),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (_recentPatients.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text('No recent patients found. Add a new patient to see them here.'),
                  ),
                )
              else
                ..._recentPatients.map((patient) => _buildPatientCard(patient)).toList(),

              const SizedBox(height: 80), // FAB ke liye space
            ],
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryGreen,
        onPressed: () async {
          final shouldRefresh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPatientScreen()),
          );
          if (shouldRefresh == true) {
            _loadDashboardData();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}