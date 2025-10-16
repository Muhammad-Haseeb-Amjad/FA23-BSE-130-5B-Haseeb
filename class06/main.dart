import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// --------------------- DATABASE HELPER ---------------------
class DatabaseHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'gpa_data.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE gpa_records (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            gpa REAL
          )
        ''');
      },
    );
  }

  static Future<void> insertRecord(double gpa) async {
    final db = await database;
    await db.insert(
      'gpa_records',
      {'date': DateTime.now().toString(), 'gpa': gpa},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getRecords() async {
    final db = await database;
    return await db.query('gpa_records', orderBy: 'id DESC');
  }
}

// --------------------- SUBJECT ROW CLASS ---------------------
class SubjectRow {
  final TextEditingController nameController;
  final TextEditingController gpaController;
  final TextEditingController creditController;

  SubjectRow({String name = '', String gpa = '', String credit = ''})
      : nameController = TextEditingController(text: name),
        gpaController = TextEditingController(text: gpa),
        creditController = TextEditingController(text: credit);

  void dispose() {
    nameController.dispose();
    gpaController.dispose();
    creditController.dispose();
  }
}

// --------------------- MAIN APP ---------------------
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BS GPA Calculator',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF0B57E2),
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2B2B2B),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6B6B6B)),
          ),
        ),
      ),
      home: const GpaCalculatorPage(),
    );
  }
}

// --------------------- GPA PAGE ---------------------
class GpaCalculatorPage extends StatefulWidget {
  const GpaCalculatorPage({super.key});
  @override
  State<GpaCalculatorPage> createState() => _GpaCalculatorPageState();
}

class _GpaCalculatorPageState extends State<GpaCalculatorPage> {
  final List<SubjectRow> _subjects = [];
  double _resultGpa = 0.0;
  List<Map<String, dynamic>> _savedRecords = [];

  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= 7; i++) {
      _subjects.add(SubjectRow(name: 'S$i'));
    }
    _loadSavedRecords();
  }

  Future<void> _loadSavedRecords() async {
    final records = await DatabaseHelper.getRecords();
    if (mounted) {
      setState(() {
        _savedRecords = records;
      });
    }
  }

  Future<void> _calculateGpa() async {
    // Shuru mein hi context ko ek variable mein save kar lein
    final scaffoldMessenger = ScaffoldMessenger.of(context as BuildContext);    double totalPoints = 0.0;
    double totalCredits = 0.0;

    for (var s in _subjects) {
      final gpaText = s.gpaController.text.trim();
      final creditText = s.creditController.text.trim();

      if (gpaText.isEmpty || creditText.isEmpty) continue;

      final gpa = double.tryParse(gpaText.replaceAll(',', '.'));
      final credits = double.tryParse(creditText.replaceAll(',', '.'));

      if (gpa == null || credits == null) continue;
      if (credits <= 0) continue;

      totalPoints += gpa * credits;
      totalCredits += credits;
    }

    if (totalCredits == 0) {
      setState(() => _resultGpa = 0.0);
    } else {
      setState(() => _resultGpa = totalPoints / totalCredits);
    }

    // Database mein GPA save karein aur list ko reload karein
    await DatabaseHelper.insertRecord(_resultGpa);
    await _loadSavedRecords();

    // Check karein ki widget abhi bhi screen par maujood hai ya nahi
    if (!mounted) return;

    // Ab save kiye gaye variable ka istemal karein
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('GPA hisaab karke save kar liya gaya hai: ${_resultGpa.toStringAsFixed(2)}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF444444),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: const [
          Expanded(flex: 3, child: Text('SUBJECTS', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Center(child: Text('GPA', style: TextStyle(fontWeight: FontWeight.bold)))),
          Expanded(flex: 2, child: Center(child: Text('CREDIT HOURS', style: TextStyle(fontWeight: FontWeight.bold)))),
        ],
      ),
    );
  }

  Widget _buildSubjectTile(int index) {
    final s = _subjects[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: s.nameController,
              decoration: InputDecoration(
                hintText: 'S${index + 1}',
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: TextField(
              controller: s.gpaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
              decoration: const InputDecoration(hintText: 'e.g. 3.00'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: TextField(
              controller: s.creditController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(hintText: 'e.g. 3'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: ElevatedButton(
        onPressed: _calculateGpa,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          backgroundColor: const Color(0xFF0B57E2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('CALCULATE', style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  Widget _buildResultCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        color: const Color(0xFF2B2B2B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Center(
            child: Text('GPA = ${_resultGpa.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildSavedRecords() {
    if (_savedRecords.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No saved GPA records yet.'),
      );
    }
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Saved GPAs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ..._savedRecords.map((rec) => ListTile(
          leading: const Icon(Icons.star, color: Colors.amber),
          title: Text('GPA: ${rec['gpa'].toStringAsFixed(2)}'),
          subtitle: Text(rec['date'].toString().split('.')[0]),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPA Calculator', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              _buildHeaderRow(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _subjects.length,
                itemBuilder: (context, i) => _buildSubjectTile(i),
              ),
              _buildCalculateButton(),
              _buildResultCard(),
              const Divider(thickness: 1),
              _buildSavedRecords(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
