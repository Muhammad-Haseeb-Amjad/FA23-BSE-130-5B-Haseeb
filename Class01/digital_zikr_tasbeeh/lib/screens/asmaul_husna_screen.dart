// lib/screens/asmaul_husna_screen.dart

import 'package:flutter/material.dart';
import '../main.dart';
import '../models/zikar_model.dart';
import 'main_counter_screen.dart';

// Dummy data for Asmaul Husna (Real data would be stored in a JSON file or database)
final List<Map<String, String>> asmaulHusnaList = [
  {'arabic': 'الرَّحْمَنُ', 'transliteration': 'Ar-Rahman', 'meaning': 'The Most Compassionate'},
  {'arabic': 'الرَّحِيمُ', 'transliteration': 'Ar-Raheem', 'meaning': 'The Most Merciful'},
  {'arabic': 'الْمَلِكُ', 'transliteration': 'Al-Malik', 'meaning': 'The King, The Sovereign'},
  {'arabic': 'الْقُدُّوسُ', 'transliteration': 'Al-Quddus', 'meaning': 'The Holy One'},
  {'arabic': 'السَّلاَمُ', 'transliteration': 'As-Salam', 'meaning': 'The Source of Peace'},
  // ... Add all 99 names here ...
];

class AsmaulHusnaScreen extends StatelessWidget {
  const AsmaulHusnaScreen({super.key});

  void _addToTasbeeh(BuildContext context, Map<String, String> nameData) {
    // Naya ZikarModel banayein, jismein Arabic aur English naam shamil ho
    final zikar = ZikarModel(
      name: nameData['transliteration']!,
      arabicText: nameData['arabic']!,
      count: 0,
      targetCount: 100, // Default target set for names of Allah
    );

    // Main Counter Screen par navigate karein aur is zikar ko load karein
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainCounterScreen(initialZikar: zikar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esmaul Husna'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          // Add New Asmaul Husna Button (As per your requirement)
          TextButton.icon(
            onPressed: () {
              // TODO: Implement logic to add a new custom name (optional)
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add New functionality TBD')));
            },
            icon: const Icon(Icons.add_circle_outline, color: kPrimaryGreen),
            label: const Text('Add New', style: TextStyle(color: kPrimaryGreen)),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: asmaulHusnaList.length,
        itemBuilder: (context, index) {
          final nameData = asmaulHusnaList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              // Name Number
              leading: CircleAvatar(
                backgroundColor: kPrimaryGreen,
                child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
              ),

              // Arabic Name
              title: Text(
                nameData['arabic']!,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'ArabicFont'), // Arabic Font ki zaroorat padegi
              ),

              // Transliteration and Meaning
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nameData['transliteration']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(nameData['meaning']!),
                ],
              ),

              // Add to Tasbeeh Button
              trailing: ElevatedButton(
                onPressed: () => _addToTasbeeh(context, nameData),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: const Text('Add to Tasbeeh', style: TextStyle(fontSize: 12, color: Colors.white)),
              ),
            ),
          );
        },
      ),
    );
  }
}