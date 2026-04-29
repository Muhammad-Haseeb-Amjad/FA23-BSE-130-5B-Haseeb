import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/dhikr.dart';
import '../services/storage_service.dart';

class AddDhikrScreen extends StatefulWidget {
  final Dhikr? dhikr;

  const AddDhikrScreen({super.key, this.dhikr});

  @override
  State<AddDhikrScreen> createState() => _AddDhikrScreenState();
}

class _AddDhikrScreenState extends State<AddDhikrScreen> {
  final StorageService _storage = StorageService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  
  late stt.SpeechToText _speechToText;
  bool _isListening = false;

  bool _hasTarget = true;
  int _currentCount = 0;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
    _initializeSpeech();
    
    if (widget.dhikr != null) {
      _isEditing = true;
      _nameController.text = widget.dhikr!.name;
      _descriptionController.text = widget.dhikr!.description;
      _hasTarget = widget.dhikr!.hasTarget;
      _currentCount = widget.dhikr!.currentCount;
      if (widget.dhikr!.targetCount != null) {
        _targetController.text = widget.dhikr!.targetCount.toString();
      }
    } else {
      _targetController.text = '33';
    }
  }
  
  Future<void> _initializeSpeech() async {
    await _speechToText.initialize(
      onError: (error) {},
      onStatus: (status) {},
    );
  }

  Future<void> _saveDhikr() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a dhikr name')),
      );
      return;
    }

    final dhikr = Dhikr(
      id: widget.dhikr?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      description: _descriptionController.text,
      currentCount: _currentCount,
      targetCount: _hasTarget ? int.tryParse(_targetController.text) : null,
      hasTarget: _hasTarget,
      icon: _getIconForName(_nameController.text),
    );

    await _storage.saveDhikr(dhikr);

    if (mounted) {
      Navigator.pop(context, dhikr);
    }
  }

  String _getIconForName(String name) {
    switch (name.toLowerCase()) {
      case 'subhanallah':
        return '🌿';
      case 'alhamdulillah':
        return '💚';
      case 'allahu akbar':
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
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetController.dispose();
    if (_isListening) {
      _speechToText.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2F2F),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Name *'),
                    const SizedBox(height: 10),
                    _buildNameTextField(),
                    const SizedBox(height: 25),
                    _buildLabel('Description (Optional)'),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _descriptionController,
                      hint: 'Benefits or notes...',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 30),
                    _buildCurrentCountSection(),
                    const SizedBox(height: 30),
                    _buildTargetSection(),
                  ],
                ),
              ),
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          Text(
            _isEditing ? 'Edit Dhikr' : 'Add New Dhikr',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(text: text.replaceAll(' *', '')),
          if (text.contains('*'))
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Color(0xFF4ADE80)),
            ),
        ],
      ),
    );
  }

  Widget _buildNameTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF234141),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: TextField(
        controller: _nameController,
        maxLines: 1,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Dhikr name (e.g. SubhanAllah)',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 16,
          ),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? const Color(0xFF4ADE80) : Colors.white.withOpacity(0.5),
            ),
            onPressed: _toggleListening,
          ),
        ),
      ),
    );
  }

  void _toggleListening() async {
    if (!_speechToText.isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech-to-text not available')),
      );
      return;
    }

    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _startListening() async {
    if (!_isListening) {
      _speechToText.listen(
        onResult: (result) {
          setState(() {
            _nameController.text = result.recognizedWords;
          });
        },
        localeId: 'ar_SA', // Arabic Saudi Arabia
      );

      setState(() {
        _isListening = true;
      });
    }
  }

  void _stopListening() async {
    if (_isListening) {
      _speechToText.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF234141),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 16,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildCurrentCountSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF234141),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text(
            'Current Count',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Color(0xFF4ADE80)),
                onPressed: () {
                  if (_currentCount > 0) {
                    setState(() {
                      _currentCount--;
                    });
                  }
                },
              ),
              const SizedBox(width: 30),
              Text(
                _currentCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 30),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF4ADE80),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFF1A2F2F)),
                  onPressed: () {
                    setState(() {
                      _currentCount++;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTargetSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF234141),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Set Target',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Set a daily goal',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              Switch(
                value: _hasTarget,
                onChanged: (value) {
                  setState(() {
                    _hasTarget = value;
                  });
                },
                activeColor: const Color(0xFF4ADE80),
                activeTrackColor: const Color(0xFF4ADE80).withOpacity(0.5),
              ),
            ],
          ),
          if (_hasTarget) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2F2F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _targetController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF4ADE80),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Text(
                    'Times',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _saveDhikr,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4ADE80),
            foregroundColor: const Color(0xFF1A2F2F),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check, size: 24),
              const SizedBox(width: 10),
              Text(
                _isEditing ? 'Update Dhikr' : 'Save Dhikr',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
