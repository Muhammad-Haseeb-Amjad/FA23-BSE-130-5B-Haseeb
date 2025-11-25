import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../models/patient_model.dart';
import '../models/visit_model.dart';
import '../database/database_helper.dart';
import 'add_visit_screen.dart'; // Agla step

class PatientDetailsScreen extends StatefulWidget {
  final Patient patient;
  const PatientDetailsScreen({super.key, required this.patient});

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  List<Visit> _visits = [];
  bool _isLoadingVisits = true;

  @override
  void initState() {
    super.initState();
    _loadVisits();
  }

  // Local database se patient ke visits load karna
  Future<void> _loadVisits() async {
    setState(() {
      _isLoadingVisits = true;
    });
    final visits = await DatabaseHelper.instance.getVisitsByPatientId(widget.patient.id!);
    setState(() {
      _visits = visits;
      _isLoadingVisits = false;
    });
  }

  // --- UPDATED PHONE CALL FUNCTION ---
  void _makeCall() async {
    final rawNumber = widget.patient.phone;
    // Non-digit characters remove karein taake dialer sirf number lay
    final cleanedNumber = rawNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri phoneUri = Uri(scheme: 'tel', path: cleanedNumber);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch phone dialer for: $rawNumber')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to initiate call.')),
      );
    }
  }

  // --- UPDATED WHATSAPP MESSAGE FUNCTION ---
  void _launchWhatsApp() async {
    final rawNumber = widget.patient.phone;
    String cleanedNumber = rawNumber.replaceAll(RegExp(r'[^\d+]'), '');

    // Logic for Pakistan number: Agar 0 se shuru ho to +92 lagao
    if (cleanedNumber.startsWith('0') && cleanedNumber.length == 11) {
      cleanedNumber = '92' + cleanedNumber.substring(1); // e.g., 0316... becomes 92316...
    }

    final message = 'Hello ${widget.patient.name}, I am contacting you regarding your appointment at the clinic.';

    // WhatsApp scheme URL with message
    final String url = 'whatsapp://send?phone=$cleanedNumber&text=${Uri.encodeComponent(message)}';
    final Uri whatsappUri = Uri.parse(url);

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        // Web Fallback (agar WhatsApp app available na ho)
        final String webUrl = 'https://wa.me/$cleanedNumber?text=${Uri.encodeComponent(message)}';
        await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp not installed or could not launch.')),
      );
    }
  }

  // Reusable card for Patient Info
  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: kPrimaryGreen),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String initials = widget.patient.name.isNotEmpty
        ? widget.patient.name.substring(0, 1).toUpperCase()
        : 'N/A';

    // Dark mode check for color adjustments
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient.name),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Patient Header (Profile Image, Name, Contact) ---
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: kPrimaryGreen.shade100,
                    child: Text(
                      initials,
                      style: TextStyle(fontSize: 40, color: kPrimaryGreen, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.patient.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Patient ID: ${widget.patient.id}',
                    style: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
                  ),
                  const SizedBox(height: 15),

                  // --- Call and WhatsApp Buttons ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _makeCall, // Call function attach hai
                        // FIX 1: 'const' removed from Text widget to allow interpolation
                        icon: const Icon(Icons.call, size: 20),
                        label: Text('Call ${widget.patient.phone}', style: const TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: _launchWhatsApp, // WhatsApp function attach hai
                        // FIX 2: Icons.whatsapp replaced with Icons.message (or Icons.chat)
                        icon: const Icon(Icons.message, size: 20),
                        label: const Text('WhatsApp', style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700, // WhatsApp ka apna green color
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- Other Info ---
            _buildInfoCard(Icons.cake, 'Age', '${widget.patient.age} years'),
            _buildInfoCard(Icons.transgender, 'Gender', widget.patient.gender),
            _buildInfoCard(Icons.location_on, 'Address', widget.patient.address),
            if (widget.patient.notes.isNotEmpty)
              _buildInfoCard(Icons.note, 'Notes', widget.patient.notes),

            const SizedBox(height: 25),

            // --- Visit History Header ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Visit History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () async {
                    // Add Visit Screen par navigate karein
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddVisitScreen(patientId: widget.patient.id!),
                      ),
                    );
                    _loadVisits(); // Visit add hone ke baad refresh
                  },
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Add Visit'),
                  style: TextButton.styleFrom(foregroundColor: kPrimaryGreen),
                ),
              ],
            ),
            Divider(color: isDarkMode ? Colors.grey.shade700 : Colors.grey),

            // --- Visit History List ---
            _isLoadingVisits
                ? const Center(child: CircularProgressIndicator())
                : _visits.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('No visit history found.'),
              ),
            )
                : ListView.builder(
              physics: const NeverScrollableScrollPhysics(), // Scrollable view ke andar list ko scrollable na rakhein
              shrinkWrap: true,
              itemCount: _visits.length,
              itemBuilder: (context, index) {
                final visit = _visits[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ExpansionTile(
                    collapsedIconColor: kPrimaryGreen,
                    iconColor: kPrimaryGreen,
                    leading: Icon(Icons.calendar_today, color: kPrimaryGreen),
                    title: Text(
                      'Visit on: ${DateFormat('dd MMM yyyy').format(DateTime.parse(visit.date))}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(visit.diagnosis),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            Text('Diagnosis: ${visit.diagnosis}', style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 5),
                            Text('Treatment: ${visit.treatment}'),
                            const SizedBox(height: 5),
                            if (visit.notes.isNotEmpty)
                              Text('Notes: ${visit.notes}', style: const TextStyle(fontStyle: FontStyle.italic)),
                            // Image display functionality yahan shamil hogi
                            if (visit.prescriptionImagePath != null && visit.prescriptionImagePath!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text('Prescription Image: (Path saved)', style: TextStyle(color: kPrimaryGreen)),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // Floating Action Button for Add Visit
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryGreen,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddVisitScreen(patientId: widget.patient.id!),
            ),
          );
          _loadVisits(); // Visit add hone ke baad refresh
        },
        child: const Icon(Icons.add_circle_outline, color: Colors.white),
      ),
    );
  }
}