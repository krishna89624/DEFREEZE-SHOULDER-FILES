import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:defreeze_shoulder/config.dart';

class EditDoctorScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const EditDoctorScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  _EditDoctorScreenState createState() => _EditDoctorScreenState();
}

class _EditDoctorScreenState extends State<EditDoctorScreen> {
  late TextEditingController _nameController;
  late TextEditingController _specializationController;
  late TextEditingController _phoneController;
  late TextEditingController _genderController;
  late TextEditingController _ageController;
  late TextEditingController _experienceController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  File? _imageFile;
  bool _isPasswordVisible = false; // Variable to toggle password visibility
  bool _isConfirmPasswordVisible = false; // Variable for confirm password visibility

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.doctor['doctorname']);
    _specializationController = TextEditingController(text: widget.doctor['specialization']);
    _phoneController = TextEditingController(text: widget.doctor['phoneno']);
    _genderController = TextEditingController(text: widget.doctor['gender']);
    _ageController = TextEditingController(text: widget.doctor['age'].toString());
    _experienceController = TextEditingController(text: widget.doctor['experience'].toString());
    _passwordController = TextEditingController(text: widget.doctor['password']);
    _confirmPasswordController = TextEditingController(text: widget.doctor['confirmpassword']);
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Widget buildTextField(String label, TextEditingController controller, IconData icon, {bool obscureText = false, VoidCallback? toggleVisibility}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF2DC2D7)),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: controller,
                obscureText: obscureText,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(color: Color(0xFF2DC2D7)),
                  border: InputBorder.none,
                  suffixIcon: toggleVisibility != null
                      ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Color(0xFF2DC2D7),
                    ),
                    onPressed: toggleVisibility,
                  )
                      : null,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '$label cannot be empty';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }

    // Regular expression for password validation
    RegExp passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$');
    if (!passwordRegExp.hasMatch(value)) {
      return 'Password must contain at least 1 uppercase letter, 1 lowercase letter, 1 digit, and be at least 8 characters long';
    }

    return null;
  }

  Future<void> _saveDoctor() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match!')),
        );
        return;
      }

      var uri = Uri.parse(Config.updateDoctorUrl);
      var request = http.MultipartRequest('POST', uri);

      // Send all necessary fields
      request.fields['doctorId'] = widget.doctor['doctorId'];
      request.fields['doctorname'] = _nameController.text;
      request.fields['specialization'] = _specializationController.text;
      request.fields['phoneno'] = _phoneController.text;
      request.fields['gender'] = _genderController.text;
      request.fields['age'] = _ageController.text;
      request.fields['experience'] = _experienceController.text;
      request.fields['password'] = _passwordController.text;
      request.fields['confirmpassword'] = _confirmPasswordController.text; // Add confirmation password

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
      }

      try {
        var response = await request.send();
        var responseBody = await http.Response.fromStream(response);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Doctor updated successfully')),
          );
          Navigator.pop(context, true); // Indicate success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update doctor')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Doctor",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFF2DC2D7),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF2DC2D7), width: 3),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _imageFile == null
                        ? NetworkImage(widget.doctor['image']) as ImageProvider
                        : FileImage(_imageFile!),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: _pickImage,
                child: Text('Change Profile Picture', style: TextStyle(color: Color(0xFF2DC2D7))),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.person, color: Color(0xFF2DC2D7)),
                  SizedBox(width: 8),
                  Text(
                    "Doctor Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              buildTextField("Doctor Name", _nameController, Icons.person),
              buildTextField("Specialization", _specializationController, Icons.medical_services),
              buildTextField("Phone No", _phoneController, Icons.phone),
              buildTextField("Gender", _genderController, Icons.person),
              buildTextField("Age", _ageController, Icons.calendar_today),
              buildTextField("Experience (in years)", _experienceController, Icons.access_time),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.lock, color: Color(0xFF2DC2D7)),
                  SizedBox(width: 8),
                  Text(
                    "Security Information",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              buildTextField("Password", _passwordController, Icons.lock, obscureText: !_isPasswordVisible, toggleVisibility: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }),
              buildTextField("Confirm Password", _confirmPasswordController, Icons.lock, obscureText: !_isConfirmPasswordVisible, toggleVisibility: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              }),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveDoctor,
                child: Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2DC2D7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
