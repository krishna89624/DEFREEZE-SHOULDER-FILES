import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart'; // For picking images
import 'config.dart'; // Import your Config file for URL

class EditDoctorProfileScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String doctorSpecialization;
  final String doctorPhone;
  final String doctorGender;
  final String doctorAge;
  final String doctorExperience;
  final String doctorPassword;
  final String doctorConfirmPassword;
  final String doctorImage;

  EditDoctorProfileScreen({
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.doctorPhone,
    required this.doctorGender,
    required this.doctorAge,
    required this.doctorExperience,
    required this.doctorPassword,
    required this.doctorConfirmPassword,
    required this.doctorImage,
  });

  @override
  _EditDoctorProfileScreenState createState() => _EditDoctorProfileScreenState();
}

class _EditDoctorProfileScreenState extends State<EditDoctorProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _specializationController;
  late TextEditingController _phoneController;
  late TextEditingController _genderController;
  late TextEditingController _ageController;
  late TextEditingController _experienceController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.doctorName);
    _specializationController =
        TextEditingController(text: widget.doctorSpecialization);
    _phoneController = TextEditingController(text: widget.doctorPhone);
    _genderController = TextEditingController(text: widget.doctorGender);
    _ageController = TextEditingController(text: widget.doctorAge);
    _experienceController =
        TextEditingController(text: widget.doctorExperience);
    _passwordController = TextEditingController(text: widget.doctorPassword);
    _confirmPasswordController =
        TextEditingController(text: widget.doctorConfirmPassword);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    _experienceController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveDoctor() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Passwords do not match!'),
          backgroundColor: Colors.red,
        ));
        return;
      }

      var uri = Uri.parse(Config.updateDoctorUrl);
      var request = http.MultipartRequest('POST', uri);

      request.fields['doctorId'] = widget.doctorId;
      request.fields['doctorname'] = _nameController.text;
      request.fields['specialization'] = _specializationController.text;
      request.fields['phoneno'] = _phoneController.text;
      request.fields['gender'] = _genderController.text;
      request.fields['age'] = _ageController.text;
      request.fields['experience'] = _experienceController.text;
      request.fields['password'] = _passwordController.text;
      request.fields['confirmpassword'] = _confirmPasswordController.text;

      if (_imageFile != null) {
        request.files.add(
            await http.MultipartFile.fromPath('image', _imageFile!.path));
      }

      try {
        var response = await request.send();
        var responseBody = await http.Response.fromStream(response);

        if (response.statusCode == 200) {
          Navigator.pop(context, true);
        } else {
          print('Failed to update doctor');
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Doctor Profile'),
        backgroundColor: Color(0xFF2DC2D7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF2DC2D7), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile == null
                        ? NetworkImage(widget.doctorImage)
                        : FileImage(_imageFile!) as ImageProvider,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2DC2D7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Change Profile Picture'),
                ),
                SizedBox(height: 20),
                _buildTextFormField(_nameController, 'Name'),
                _buildTextFormField(
                    _specializationController, 'Specialization'),
                _buildTextFormField(_phoneController, 'Phone'),
                _buildTextFormField(_genderController, 'Gender'),
                _buildTextFormField(
                    _ageController, 'Age', keyboardType: TextInputType.number),
                _buildTextFormField(_experienceController, 'Experience (years)',
                    keyboardType: TextInputType.number),
                _buildPasswordFormField(_passwordController, 'Password'),
                _buildPasswordFormField(
                    _confirmPasswordController, 'Confirm Password'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveDoctor,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2DC2D7),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller,
      String labelText, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Color(0xFF2DC2D7)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF2DC2D7), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF2DC2D7), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordFormField(TextEditingController controller,
      String labelText) {
    // Regex for password validation:
    // At least one uppercase letter, one lowercase letter, one digit, and at least 8 characters
    String passwordPattern = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: labelText == 'Password'
            ? !_isPasswordVisible
            : !_isConfirmPasswordVisible,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Color(0xFF2DC2D7)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF2DC2D7), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF2DC2D7), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[100],
          suffixIcon: IconButton(
            icon: Icon(
              labelText == 'Password' ? (_isPasswordVisible ? Icons
                  .visibility_off : Icons.visibility)
                  : (_isConfirmPasswordVisible ? Icons.visibility_off : Icons
                  .visibility),
              color: Color(0xFF2DC2D7),
            ),
            onPressed: () {
              setState(() {
                if (labelText == 'Password') {
                  _isPasswordVisible = !_isPasswordVisible;
                } else {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                }
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a $labelText';
          }
          // Check password pattern
          if (!RegExp(passwordPattern).hasMatch(value)) {
            return 'Password must contain at least one uppercase letter, one lowercase letter, one digit, and be at least 8 characters long';
          }
          return null;
        },
      ),
    );
  }
}