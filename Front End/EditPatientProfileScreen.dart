import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'config.dart';

class EditPatientProfileScreen extends StatefulWidget {
  final Map<String, dynamic> patientDetails;
  final String doctorId;
  final String image;
  final String patientId;

  EditPatientProfileScreen({
    required this.patientDetails,
    required this.doctorId,
    required this.image,
    required this.patientId,
  });

  @override
  _EditPatientProfileScreenState createState() => _EditPatientProfileScreenState();
}

class _EditPatientProfileScreenState extends State<EditPatientProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _contactNoController;
  late TextEditingController _genderController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _painDurationController;
  late TextEditingController _patientCaseController;
  late TextEditingController _admittedOnController;
  late TextEditingController _rbsController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _patientIdController;
  late TextEditingController _doctorIdController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? _imageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.patientDetails['name']);
    _contactNoController =
        TextEditingController(text: widget.patientDetails['contactNo']);
    _genderController =
        TextEditingController(text: widget.patientDetails['gender']);
    _ageController = TextEditingController(text: widget.patientDetails['age']);
    _heightController =
        TextEditingController(text: widget.patientDetails['height']);
    _weightController =
        TextEditingController(text: widget.patientDetails['weight']);
    _painDurationController =
        TextEditingController(text: widget.patientDetails['painDuration']);
    _patientCaseController =
        TextEditingController(text: widget.patientDetails['patientCase']);
    _admittedOnController =
        TextEditingController(text: widget.patientDetails['admittedOn']);
    _rbsController = TextEditingController(text: widget.patientDetails['rbs']);
    _passwordController =
        TextEditingController(text: widget.patientDetails['password']);
    _confirmPasswordController =
        TextEditingController(text: widget.patientDetails['confirmPassword']);
    _patientIdController = TextEditingController(text: widget.patientId);
    _doctorIdController = TextEditingController(text: widget.doctorId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactNoController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _painDurationController.dispose();
    _patientCaseController.dispose();
    _admittedOnController.dispose();
    _rbsController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _patientIdController.dispose();
    _doctorIdController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2DC2D7),
        title: Text('Edit Patient Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Displaying the image
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF2DC2D7), width: 3),
                    image: DecorationImage(
                      image: _imageFile != null
                          ? FileImage(File(_imageFile!.path))
                          : (widget.image.isNotEmpty
                          ? NetworkImage(widget.image)
                          : AssetImage(
                          'assets/default_profile.png') as ImageProvider),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Button to select an image
              IconButton(
                icon: Icon(Icons.photo, color: Color(0xFF2DC2D7)),
                onPressed: _selectImage,
              ),

              // Patient Details Section
              ExpansionTile(
                title: Text('Patient Details'),
                children: [

                  _buildTextField('Name', _nameController),
                  _buildTextField('Contact No', _contactNoController),
                  _buildTextField('Gender', _genderController),
                  _buildTextField('Age', _ageController),
                  _buildTextField('Height (cm)', _heightController),
                  _buildTextField('Weight (kg)', _weightController),
                  _buildTextField('Pain Duration', _painDurationController),
                  _buildTextField('Patient Case', _patientCaseController),
                  _buildTextField('Admitted On', _admittedOnController),
                  _buildTextField('RBS (mg/dL)', _rbsController),
                ],
              ),

              SizedBox(height: 20),

              // Security Information Section
              ExpansionTile(
                title: Text('Security Information'),
                children: [
                  _buildTextField('Password', _passwordController),
                  _buildTextField(
                      'Confirm Password', _confirmPasswordController),
                ],
              ),

              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2DC2D7),
                ),
                onPressed: () {
                  _updatePatientDetails();
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _updatePatientDetails() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Passwords do not match, show error message
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Password validation (at least 8 characters, 1 uppercase letter, 1 number)
    String password = _passwordController.text;
    RegExp passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$');

    if (!passwordRegExp.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Password must be at least 8 characters, contain 1 uppercase letter, and 1 number.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Config.updatePatientUrl),
      );

      request.fields['patientId'] = widget.patientId;
      request.fields['name'] = _nameController.text;
      request.fields['contactNo'] = _contactNoController.text;
      request.fields['age'] = _ageController.text;
      request.fields['gender'] = _genderController.text;
      request.fields['height'] = _heightController.text;
      request.fields['weight'] = _weightController.text;
      request.fields['patientCase'] = _patientCaseController.text;
      request.fields['painDuration'] = _painDurationController.text;
      request.fields['admittedOn'] = _admittedOnController.text;
      request.fields['rbs'] = _rbsController.text;
      request.fields['password'] = _passwordController.text;
      request.fields['confirmPassword'] = _confirmPasswordController.text;
      request.fields['doctorId'] = widget.doctorId;

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _imageFile!.path,
        ));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        // Show success message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Patient details updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate back to the previous screen after a short delay
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } else {
        // Show error message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update patient details'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      // Show error message using SnackBar in case of exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}