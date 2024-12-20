import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class EditPatientScreen extends StatefulWidget {
  final String image;
  final String patientId;
  final String name;
  final String contactNo;
  final int age;
  final String gender;
  final double height;
  final double weight;
  final String patientCase;
  final String painDuration;
  final String admittedOn;
  final double rbs;
  final String password;
  final String confirmPassword;
  final String doctorId;

  const EditPatientScreen({
    Key? key,
    required this.image,
    required this.patientId,
    required this.name,
    required this.contactNo,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.patientCase,
    required this.painDuration,
    required this.admittedOn,
    required this.rbs,
    required this.password,
    required this.confirmPassword,
    required this.doctorId,
  }) : super(key: key);

  @override
  _EditPatientScreenState createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final contactNoController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final patientCaseController = TextEditingController();
  final painDurationController = TextEditingController();
  final admittedOnController = TextEditingController();
  final rbsController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  final Color primaryColor = const Color(0xFF2DC2D7);

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    contactNoController.text = widget.contactNo;
    ageController.text = widget.age.toString();
    genderController.text = widget.gender;
    heightController.text = widget.height.toString();
    weightController.text = widget.weight.toString();
    patientCaseController.text = widget.patientCase;
    painDurationController.text = widget.painDuration;
    admittedOnController.text = widget.admittedOn;
    rbsController.text = widget.rbs.toString();
    passwordController.text = widget.password;
    confirmPasswordController.text = widget.confirmPassword;
    _imageFile = widget.image.startsWith('http') ? null : File(widget.image);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Password validation function
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    // Regular expression for password validation
    final passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$');
    if (!passwordRegExp.hasMatch(value)) {
      return 'Password must be at least 8 characters, contain 1 uppercase letter, and 1 number';
    }
    return null;
  }

  Future<void> _updatePatientDetails() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Ensure passwords match
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match. Please try again.'),
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
      request.fields['name'] = nameController.text;
      request.fields['contactNo'] = contactNoController.text;
      request.fields['age'] = ageController.text;
      request.fields['gender'] = genderController.text;
      request.fields['height'] = heightController.text;
      request.fields['weight'] = weightController.text;
      request.fields['patientCase'] = patientCaseController.text;
      request.fields['painDuration'] = painDurationController.text;
      request.fields['admittedOn'] = admittedOnController.text;
      request.fields['rbs'] = rbsController.text;
      request.fields['password'] = passwordController.text;
      request.fields['confirmPassword'] = confirmPasswordController.text;
      request.fields['doctorId'] = widget.doctorId;

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _imageFile!.path,
        ));
      }

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        Navigator.pop(context, {
          'patientId': widget.patientId,
          'imageUri': _imageFile?.path ?? widget.image,
        });
      } else {
        print('Error updating patient details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon,
      {TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: primaryColor),
        title: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          keyboardType: keyboardType,
          validator: validator ?? (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the $label';
            }
            return null;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Patient Details'),
        backgroundColor: primaryColor,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updatePatientDetails,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: primaryColor,
                  child: CircleAvatar(
                    radius: 75,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : widget.image.startsWith('http')
                        ? NetworkImage(widget.image)
                        : AssetImage('assets/placeholder.png') as ImageProvider,
                    child: _imageFile == null
                        ? Icon(Icons.camera_alt, size: 60, color: Colors.grey.shade700)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildSectionTitle('Patient Details'),
              _buildTextField('Name', nameController, Icons.person),
              _buildTextField('Contact Number', contactNoController, Icons.phone, keyboardType: TextInputType.phone),
              _buildTextField('Age', ageController, Icons.calendar_today, keyboardType: TextInputType.number),
              _buildTextField('Gender', genderController, Icons.wc),
              _buildTextField('Height', heightController, Icons.height, keyboardType: TextInputType.number),
              _buildTextField('Weight', weightController, Icons.fitness_center, keyboardType: TextInputType.number),

              _buildSectionTitle('Additional Information'),
              _buildTextField('Patient Case', patientCaseController, Icons.description),
              _buildTextField('Pain Duration', painDurationController, Icons.timer),
              _buildTextField('Admitted On', admittedOnController, Icons.date_range),
              _buildTextField('RBS', rbsController, Icons.bloodtype, keyboardType: TextInputType.number),

              _buildSectionTitle('Security'),
              _buildTextField('Password', passwordController, Icons.lock, validator: _validatePassword),
              _buildTextField('Confirm Password', confirmPasswordController, Icons.lock_outline, validator: (value) {
                if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              }),
            ],
          ),
        ),
      ),
    );
  }
}
