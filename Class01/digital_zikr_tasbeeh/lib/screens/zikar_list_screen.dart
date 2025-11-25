// lib/screens/zikar_list_screen.dart

import 'package:flutter/material.dart';
import '../main.dart';
import '../models/zikar_model.dart';
import '../database/database_helper.dart';
import 'main_counter_screen.dart';
import 'save_zikar_screen.dart';

class ZikarListScreen extends StatefulWidget {
  const ZikarListScreen({super.key});

  @override
  State<ZikarListScreen> createState() => _ZikarListScreenState();
}

class _ZikarListScreenState extends State<ZikarListScreen> {
  Future<List<ZikarModel>>? _zikarListFuture;

  @override
  void initState() {
    super.initState();
    _loadZikarList();
  }

  void _loadZikarList() {
    setState(() {
      _zikarListFuture = DatabaseHelper.instance.getAllZikar();
    });
  }

  void _deleteZikar(int id) async {
    await DatabaseHelper.instance.deleteZikar(id);
    _loadZikarList(); // Refresh the list
  }

  void _continueZikar(ZikarModel zikar) {
    // Navigate to Main Counter Screen with the selected zikar
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainCounterScreen(initialZikar: zikar)),
          (Route<dynamic> route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zikr List'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Add New Zikr Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SaveZikarScreen()),
                );
                _loadZikarList(); // Refresh after adding a new zikar
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add new zikr', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentPurple,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),

          // Zikar List
          Expanded(
            child: FutureBuilder<List<ZikarModel>>(
              future: _zikarListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No saved Zikr found.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    ZikarModel zikar = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: kAccentPurple,
                          child: Text(
                            zikar.count.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(zikar.name),
                        subtitle: Text(zikar.arabicText ?? 'No Arabic Text'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SaveZikarScreen(zikar: zikar)),
                              );
                              _loadZikarList();
                            } else if (value == 'continue') {
                              _continueZikar(zikar);
                            } else if (value == 'delete') {
                              _deleteZikar(zikar.id!);
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'continue',
                              child: Text('Continue'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                          icon: const Icon(Icons.more_vert),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}