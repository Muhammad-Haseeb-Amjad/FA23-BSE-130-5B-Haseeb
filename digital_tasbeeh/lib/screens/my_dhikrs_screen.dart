import 'package:flutter/material.dart';
import '../models/dhikr.dart';
import '../services/storage_service.dart';
import '../utils/app_message.dart';
import '../utils/dhikr_display.dart';
import 'add_dhikr_screen.dart';

class MyDhikrsScreen extends StatefulWidget {
  const MyDhikrsScreen({super.key});

  @override
  State<MyDhikrsScreen> createState() => _MyDhikrsScreenState();
}

class _MyDhikrsScreenState extends State<MyDhikrsScreen> {
  final StorageService _storage = StorageService();
  List<Dhikr> _dhikrs = [];
  List<Dhikr> _filteredDhikrs = [];
  bool _isLoading = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDhikrs();
  }

  Future<void> _loadDhikrs() async {
    final dhikrs = await _storage.loadDhikrs();
    setState(() {
      _dhikrs = dhikrs;
      _filteredDhikrs = dhikrs;
      _isLoading = false;
    });
  }

  void _filterDhikrs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDhikrs = _dhikrs;
      } else {
        _filteredDhikrs = _dhikrs
            .where((dhikr) =>
                dhikr.name.toLowerCase().contains(query.toLowerCase()) ||
                dhikr.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _deleteDhikr(String id, String name) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF234141),
        title: const Text(
          'Delete Dhikr?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "$name"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Color(0xFFFF6B6B))),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;
    await _storage.deleteDhikr(id);
    if (!mounted) return;
    showAppMessage(context, '"$name" deleted successfully');
    _loadDhikrs();
  }

  void _navigateToAddDhikr() async {
    final result = await Navigator.push<Dhikr?>(
      context,
      MaterialPageRoute(builder: (context) => const AddDhikrScreen()),
    );

    if (result != null) {
      _loadDhikrs();
    }
  }

  void _navigateToEditDhikr(Dhikr dhikr) async {
    final result = await Navigator.push<Dhikr?>(
      context,
      MaterialPageRoute(builder: (context) => AddDhikrScreen(dhikr: dhikr)),
    );

    if (result != null) {
      _loadDhikrs();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectDhikr(Dhikr dhikr) {
    Navigator.pop(context, dhikr);
  }

  String _getIconForDhikr(String name) {
    switch (name.toLowerCase()) {
      case 'subhanallah':
      case 'سُبْحَانَ ٱللّٰهِ':
        return '🌿';
      case 'alhamdulillah':
      case 'ٱلْحَمْدُ لِلّٰهِ':
        return '💚';
      case 'allahu akbar':
      case 'ٱللّٰهُ أَكْبَرُ':
        return '⭐';
      case 'istighfar':
        return '💧';
      case 'la ilaha illallah':
        return '🕌';
      default:
        return '🌿';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            if (_isSearching)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  onChanged: (value) {
                    setState(() {
                      _filterDhikrs(value);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search dhikrs...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white70),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _filterDhikrs('');
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                  ),
                ),
              ),
            if (_isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF4ADE80)),
                ),
              )
            else if (_filteredDhikrs.isEmpty)
              _buildEmptyState()
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _filteredDhikrs.length,
                  itemBuilder: (context, index) {
                    return _buildDhikrCard(_filteredDhikrs[index]);
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddDhikr,
        backgroundColor: const Color(0xFF4ADE80),
        child: const Icon(Icons.add, color: Color(0xFF1A2F2F), size: 32),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (_isSearching) {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  _filteredDhikrs = _dhikrs;
                });
              } else {
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(width: 10),
          if (!_isSearching)
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Dhikrs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _filteredDhikrs = _dhikrs;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 20),
            Text(
              'Empty State Preview',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your heart is at rest. Start a new Dhikr\nto begin your journey.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDhikrCard(Dhikr dhikr) {
    final icon = _getIconForDhikr(dhikr.name);
    final isCompleted = dhikr.isCompleted;
    final hasTarget = dhikr.hasTarget && dhikr.targetCount != null;

    return GestureDetector(
      onTap: () => _selectDhikr(dhikr),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF234141),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D5555),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getDhikrDisplayName(dhikr.name),
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isArabic(getDhikrDisplayName(dhikr.name)) ? 26 : 22,
                          fontFamily: isArabic(getDhikrDisplayName(dhikr.name)) ? 'Amiri' : null,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        dhikr.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4ADE80),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Color(0xFF1A2F2F),
                      size: 30,
                    ),
                  )
                else if (hasTarget)
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: dhikr.currentCount / dhikr.targetCount!,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            color: const Color(0xFF4ADE80),
                            strokeWidth: 4,
                          ),
                        ),
                        Text(
                          dhikr.currentCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    dhikr.currentCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                if (hasTarget)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.my_location,
                          color: Color(0xFF4ADE80),
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Target: ${dhikr.targetCount}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.all_inclusive,
                          color: Colors.white.withOpacity(0.7),
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Open Count',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ADE80).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF4ADE80),
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Completed: ${dhikr.currentCount}',
                          style: const TextStyle(
                            color: Color(0xFF4ADE80),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white70),
                  onPressed: () => _navigateToEditDhikr(dhikr),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white70),
                  onPressed: () => _deleteDhikr(dhikr.id, dhikr.name),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
