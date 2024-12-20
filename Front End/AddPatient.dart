import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'config.dart'; // Adjust the import according to your project's structure

class AddPatient extends StatefulWidget {
  final String doctorId;

  const AddPatient({Key? key, required this.doctorId}) : super(key: key);

  @override
  _AddPatientState createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _patientIdController = TextEditingController(); // Added patientIdController
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _patientCaseController = TextEditingController();
  final TextEditingController _painDurationController = TextEditingController();
  final TextEditingController _rbsController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _gender;
  DateTime? _admittedOn;
  String? _imagePath;

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  bool _isPasswordValid(String password) {
    // Password must have at least 8 characters, 1 uppercase letter, 1 number, and the rest lowercase
    RegExp passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  bool _isContactNumberValid(String contactNo) {
    // Validate if contact number is digits only and at least 10 digits long
    RegExp contactRegExp = RegExp(r'^\d{10}$');
    return contactRegExp.hasMatch(contactNo);
  }

  void _handleSubmit() async {
    // Validate patient ID (should start with P)
    if (!_patientIdController.text.startsWith('P')) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Patient ID must start with a capital "P"')));
      return;
    }
    if (!_isContactNumberValid(_contactNoController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Contact number must be 10 digits')));
      return;
    }
    // Validate image selection
    if (_imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an image')));
      return;
    }

    // Validate password and confirm password
    if (!_isPasswordValid(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password must be at least 8 characters, contain 1 uppercase letter, and 1 number')));
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match')));
      return;
    }

    // Validate all fields
    if (_nameController.text.isEmpty ||
        _patientIdController.text.isEmpty || // Validate Patient ID field
        _contactNoController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _gender == null ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _patientCaseController.text.isEmpty ||
        _painDurationController.text.isEmpty ||
        _rbsController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _admittedOn == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all required fields')));
      return;
    }

    // Proceed to send data if everything is valid
    var uri = Uri.parse(Config.addpatient1Url);
    var request = http.MultipartRequest('POST', uri);

    // Add form fields to the request
    request.fields['name'] = _nameController.text;
    request.fields['contactNo'] = _contactNoController.text;
    request.fields['age'] = _ageController.text;
    request.fields['gender'] = _gender!;
    request.fields['height'] = _heightController.text;
    request.fields['weight'] = _weightController.text;
    request.fields['patientCase'] = _patientCaseController.text;
    request.fields['painDuration'] = _painDurationController.text;
    request.fields['admittedOn'] = DateFormat('yyyy-MM-dd').format(_admittedOn!);
    request.fields['rbs'] = _rbsController.text;
    request.fields['password'] = _passwordController.text;
    request.fields['confirmPassword'] = _confirmPasswordController.text;
    request.fields['doctorId'] = widget.doctorId;
    request.fields['patientId'] = _patientIdController.text; // Added patientId to request fields

    // Add the image file if it’s selected
    if (_imagePath != null) {
      var imageFile = await http.MultipartFile.fromPath('image', _imagePath!);
      request.files.add(imageFile);
    }

    try {
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseData.body);

        if (jsonResponse['success']) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(jsonResponse['message'])));
          Navigator.pop(context); // Navigate back to the previous screen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(jsonResponse['message'])));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Server error: ${response.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Patient'),
        backgroundColor: Color(0xFF2DC2D7), // Updated color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Color(0xFF2DC2D7)), // Updated color
            ),
            const SizedBox(height: 20),
            _buildTextField(_nameController, 'Name'),
            _buildTextField(_patientIdController, 'Patient ID (starts with P)'), // Added Patient ID field
            _buildTextField(_contactNoController, 'Contact No', keyboardType: TextInputType.number),
            _buildTextField(_ageController, 'Age', keyboardType: TextInputType.number),
            _buildGenderDropdown(),
            _buildTextField(_heightController, 'Height (cm)', keyboardType: TextInputType.number),
            _buildTextField(_weightController, 'Weight (kg)', keyboardType: TextInputType.number),
            _buildTextField(_patientCaseController, 'Patient Case'),
            _buildTextField(_painDurationController, 'Pain Duration'),
            _buildTextField(_rbsController, 'RBS', keyboardType: TextInputType.number),
            _buildImagePicker(),
            _buildTextField(_passwordController, 'Password', obscureText: true),
            _buildTextField(_confirmPasswordController, 'Confirm Password', obscureText: true),
            _buildDatePicker(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2DC2D7), // Updated color
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFF2DC2D7)), // Updated color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFF2DC2D7)), // Updated color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFF2DC2D7)), // Updated color
          ),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        value: _gender,
        hint: const Text('Select Gender'),
        onChanged: (value) {
          setState(() {
            _gender = value;
          });
        },
        items: ['Male', 'Female', 'Other'].map((gender) {
          return DropdownMenuItem(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: 'Gender',
          labelStyle: TextStyle(color: Color(0xFF2DC2D7)), // Updated color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFF2DC2D7)), // Updated color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFF2DC2D7)), // Updated color
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _imagePath == null
              ? const Icon(Icons.add_a_photo, size: 50, color: Color(0xFF2DC2D7)) // Updated color
              : Image.file(File(_imagePath!), width: 50, height: 50),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: _selectImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2DC2D7), // Updated color
            ),
            child: const Text('Select Image'),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            setState(() {
              _admittedOn = pickedDate;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2DC2D7), // Updated color
        ),
        child: Text(_admittedOn == null
            ? 'Select Admitted On Date'
            : DateFormat('yyyy-MM-dd').format(_admittedOn!)),
      ),
    );
  }
}
