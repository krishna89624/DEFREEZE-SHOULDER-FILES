import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart'; // Import your config file for baseUrl

class DailyActivityScreen extends StatefulWidget {
  final String patientId;

  const DailyActivityScreen({required this.patientId, Key? key}) : super(key: key);

  @override
  _DailyActivityScreenState createState() => _DailyActivityScreenState();
}

class _DailyActivityScreenState extends State<DailyActivityScreen> {
  final TextEditingController flexionController = TextEditingController();
  final TextEditingController extensionController = TextEditingController();
  final TextEditingController adductionController = TextEditingController();
  final TextEditingController abductionController = TextEditingController();
  final TextEditingController painScaleController = TextEditingController();
  bool? isDoingExercises;

  Future<void> submitForm() async {
    if (isDoingExercises == null) {
      _showErrorDialog('Please select an option for doing exercises');
      return;
    }

    final url = Uri.parse(Config.submitActivityUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'patientId': widget.patientId,
        'flexion': flexionController.text,
        'extension': extensionController.text,
        'adduction': adductionController.text,
        'abduction': abductionController.text,
        'pain_scale': painScaleController.text,
        'doing_exercises': isDoingExercises! ? 'Yes' : 'No',
      },
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success']) {
      _showSuccessDialog('Task submitted successfully');
    } else {
      _showErrorDialog(data['message'] ?? 'Failed to submit task. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context); // Navigate back to the previous screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Activity'),
        backgroundColor: Color(0xFF2DC2D7),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('1. Range of movement'),
            _buildMovementInputRow('Flexion', flexionController, '°', 'Extension', extensionController, '°'),
            _buildImage('assets/IMG_8264 3.png'),
            _buildMovementInputRow('Adduction', adductionController, '°', 'Abduction', abductionController, '°'),
            _buildImage('assets/IMG_8264 1.png'),
            _buildSectionTitle('2. Pain scale (1 to 10)'),
            _buildTextInput(painScaleController, 'Pain Scale'),
            _buildSectionTitle('3. Doing Exercises'),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildCheckboxOption('Yes', true),
                SizedBox(width: 10),
                _buildCheckboxOption('No', false),
              ],
            ),
            SizedBox(height: 24), // Added space between doing exercises and submit button
            Center(
              child: ElevatedButton(
                onPressed: submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2DC2D7),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                child: Text('Submit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2DC2D7)),
      ),
    );
  }

  Widget _buildMovementInputRow(String label1, TextEditingController controller1, String degreeSymbol1, String label2, TextEditingController controller2, String degreeSymbol2) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label1, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800])),
                _buildTextInputWithDegreeSymbol(controller1, degreeSymbol1),
              ],
            ),
          ),
          SizedBox(width: 16), // Space between the two input fields
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label2, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800])),
                _buildTextInputWithDegreeSymbol(controller2, degreeSymbol2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput(TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: hintText,
          filled: true,
          fillColor: Color(0xFFF5F5F5),
        ),
      ),
    );
  }

  Widget _buildTextInputWithDegreeSymbol(TextEditingController controller, String degreeSymbol) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'Input',
                filled: true,
                fillColor: Color(0xFFF5F5F5),
              ),
            ),
          ),
          Text(degreeSymbol, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildCheckboxOption(String label, bool value) {
    return GestureDetector(
      onTap: () => setState(() => isDoingExercises = value),
      child: Container(
        decoration: BoxDecoration(
          color: isDoingExercises == value ? Color(0xFF2DC2D7) : Colors.white,
          border: Border.all(color: isDoingExercises == value ? Colors.transparent : Colors.grey),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            if (isDoingExercises == value)
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 3),
                blurRadius: 6,
              )
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isDoingExercises == value ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          assetPath,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
