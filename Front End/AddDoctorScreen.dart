import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class AddDoctorScreen extends StatefulWidget {
  @override
  _AddDoctorScreenState createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  final TextEditingController _doctorIdController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _doctorIdError;

  static const Color primaryColor = Color(0xFF2DC2D7);

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() == true) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      // Validate Doctor ID
      if (!_validateDoctorId(_doctorIdController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Doctor ID must start with a capital "D"')),
        );
        return;
      }

      // Validate Password
      if (!_validatePassword(_passwordController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password must be at least 8 characters, contain at least one uppercase letter, and the remaining characters must be a mix of lowercase letters and numbers.')),
        );
        return;
      }

      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an image')),
        );
        return;
      }

      try {
        var uri = Uri.parse(Config.addDoctorUrl);
        var request = http.MultipartRequest('POST', uri);

        request.fields['doctorId'] = _doctorIdController.text;
        request.fields['doctorname'] = _doctorNameController.text;
        request.fields['phoneno'] = _phoneController.text;
        request.fields['gender'] = _genderController.text;
        request.fields['age'] = _ageController.text;
        request.fields['experience'] = _experienceController.text;
        request.fields['specialization'] = _specializationController.text;
        request.fields['password'] = _passwordController.text;
        request.fields['confirmpassword'] = _confirmPasswordController.text;

        if (_imageFile != null) {
          var stream = http.ByteStream(_imageFile!.openRead());
          var length = await _imageFile!.length();
          var multipartFile = http.MultipartFile(
            'image',
            stream,
            length,
            filename: _imageFile!.path.split('/').last,
          );
          request.files.add(multipartFile);
        }

        print('Sending data to server at: ${Config.addDoctorUrl}');
        var response = await request.send();

        if (response.statusCode == 200) {
          var responseData = await http.Response.fromStream(response);
          var responseJson = json.decode(responseData.body);
          print('Server response: $responseJson');

          if (responseJson['success']) {
            _clearForm();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Success'),
                  content: Text('Doctor details submitted successfully.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/AdminDashboard');
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            String message = responseJson['message'] ?? 'Unknown error';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        } else {
          print('Error: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error submitting form. Please try again.')),
          );
        }
      } catch (error) {
        print('Error submitting form: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting form. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields')),
      );
    }
  }

// Function to validate Doctor ID (must start with capital "D")
  bool _validateDoctorId(String doctorId) {
    return doctorId.isNotEmpty && doctorId[0] == 'D';
  }

// Function to validate Password (at least 8 chars, at least one uppercase letter, remaining lowercase letters and numbers)
  bool _validatePassword(String password) {
    // Regex: Must contain at least one uppercase letter, one lowercase letter, one number, and be at least 8 characters
    RegExp passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return passwordRegExp.hasMatch(password);
  }
  void _clearForm() {
    setState(() {
      _doctorIdController.clear();
      _doctorNameController.clear();
      _phoneController.clear();
      _genderController.clear();
      _ageController.clear();
      _experienceController.clear();
      _specializationController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _imageFile = null;
      _doctorIdError = null;
    });
  }

  @override
  void dispose() {
    _doctorIdController.dispose();
    _doctorNameController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    _experienceController.dispose();
    _specializationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Doctor Details"),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? Icon(Icons.camera_alt, size: 50, color: primaryColor)
                        : null,
                  ),
                ),
                SizedBox(height: 10),
                Text("Upload Image", style: TextStyle(fontSize: 16, color: primaryColor)),

                SizedBox(height: 20),

                _buildTextField(
                  controller: _doctorIdController,
                  labelText: 'Doctor ID (e.g., D123)',
                  errorText: _doctorIdError,
                ),
                SizedBox(height: 10),

                _buildTextField(
                  controller: _doctorNameController,
                  labelText: 'Doctor Name',
                ),
                SizedBox(height: 10),

                _buildTextField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 10),

                _buildTextField(
                  controller: _genderController,
                  labelText: 'Gender',
                ),
                SizedBox(height: 10),

                _buildTextField(
                  controller: _ageController,
                  labelText: 'Age',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),

                _buildTextField(
                  controller: _experienceController,
                  labelText: 'Experience (Years)',
                ),
                SizedBox(height: 10),

                _buildTextField(
                  controller: _specializationController,
                  labelText: 'Specialization',
                ),
                SizedBox(height: 10),

                _buildPasswordField(_passwordController, 'Password'),
                SizedBox(height: 10),

                _buildPasswordField(_confirmPasswordController, 'Confirm Password'),
                SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2DC2D7),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: Text('Submit', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
      obscureText: true,
    );
  }
}
