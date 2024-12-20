import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'config.dart';  // Assuming config.dart has the URL details

class AddPatientScreen extends StatefulWidget {
  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  DateTime _admittedOn = DateTime.now();

  List<dynamic> doctors = [];
  bool _isLoading = false;

  // Patient details
  final TextEditingController _patientIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _patientCaseController = TextEditingController();
  final TextEditingController _painDurationController = TextEditingController();
  final TextEditingController _rbsController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _selectedDoctorId;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final response = await http.get(Uri.parse(Config.addadnindocUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          doctors = data;
        });
      } else {
        throw Exception('Failed to fetch doctors');
      }
    } catch (error) {
      print('Error fetching doctors: $error');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match')));
      return;
    }

    // Password Validation
    final password = _passwordController.text;
    final passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (!passwordRegExp.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number')));
      return;
    }

    // Check if image is selected
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an image')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var request = http.MultipartRequest('POST', Uri.parse(Config.addpatientUrl));

      // Add form fields
      request.fields['doctorId'] = _selectedDoctorId ?? '';
      request.fields['patientId'] = _patientIdController.text;
      request.fields['name'] = _nameController.text;
      request.fields['contactNo'] = _contactNoController.text;
      request.fields['age'] = _ageController.text;
      request.fields['gender'] = _selectedGender ?? '';
      request.fields['height'] = _heightController.text;
      request.fields['weight'] = _weightController.text;
      request.fields['patientCase'] = _patientCaseController.text;
      request.fields['painDuration'] = _painDurationController.text;
      request.fields['admittedOn'] = DateFormat('yyyy-MM-dd').format(_admittedOn);
      request.fields['rbs'] = _rbsController.text;
      request.fields['password'] = _passwordController.text;
      request.fields['confirmPassword'] = _confirmPasswordController.text;

      // Add image if exists
      var stream = http.ByteStream(_imageFile!.openRead());
      var length = await _imageFile!.length();
      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: _imageFile!.path.split('/').last,
      );
      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var responseJson = json.decode(responseData.body);
        if (responseJson['success']) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Patient added successfully')));
          _clearForm();
          Navigator.pop(context); // Navigate back after success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseJson['message'])));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add patient')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }




  void _clearForm() {
    _formKey.currentState?.reset();
    _patientIdController.clear();
    _nameController.clear();
    _contactNoController.clear();
    _ageController.clear();
    _heightController.clear();
    _weightController.clear();
    _patientCaseController.clear();
    _painDurationController.clear();
    _rbsController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _selectedDoctorId = null;
      _selectedGender = null;
      _imageFile = null;
      _admittedOn = DateTime.now();
    });
  }

  @override
  void dispose() {
    _patientIdController.dispose();
    _nameController.dispose();
    _contactNoController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _patientCaseController.dispose();
    _painDurationController.dispose();
    _rbsController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Patient"),
        backgroundColor: Color(0xFF2DC2D7),  // Setting the AppBar color
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,  // Center alignment
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? Icon(Icons.camera_alt, size: 50, color: Colors.grey[700])
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(child: Text("Tap to upload profile image", style: TextStyle(color: Colors.grey[600]))),
              SizedBox(height: 20),
              // Patient ID
              TextFormField(
                controller: _patientIdController,
                decoration: InputDecoration(labelText: 'Patient ID', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter patient ID';
                  if (!RegExp(r'^P\d+$').hasMatch(value)) return 'Patient ID must start with "P" followed by numbers';
                  return null;
                },
              ),
              SizedBox(height: 10),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Please enter name' : null,
              ),
              SizedBox(height: 10),

              // Contact No
              TextFormField(
                controller: _contactNoController,
                decoration: InputDecoration(labelText: 'Contact No', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Please enter contact number' : null,
              ),
              SizedBox(height: 10),

              // Age
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter age' : null,
              ),
              SizedBox(height: 10),

              // Gender
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
                value: _selectedGender,
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem<String>(value: gender, child: Text(gender)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) => value == null ? 'Please select gender' : null,
              ),
              SizedBox(height: 10),

              // Doctor Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Doctor', border: OutlineInputBorder()),
                value: _selectedDoctorId,
                items: doctors.map((doctor) {
                  final doctorId = doctor['doctorId'];
                  final doctorName = doctor['doctorname'];
                  return DropdownMenuItem<String>(
                    value: doctorId,
                    child: Text(doctorId),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDoctorId = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a doctor' : null,
              ),
              SizedBox(height: 10),

              // Height
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height (cm)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter height' : null,
              ),
              SizedBox(height: 10),

              // Weight
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter weight' : null,
              ),
              SizedBox(height: 10),

              // Patient Case
              TextFormField(
                controller: _patientCaseController,
                decoration: InputDecoration(labelText: 'Patient Case', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Please enter patient case' : null,
              ),
              SizedBox(height: 10),

              // Pain Duration
              TextFormField(
                controller: _painDurationController,
                decoration: InputDecoration(labelText: 'Pain Duration (days)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter pain duration' : null,
              ),
              SizedBox(height: 10),

              // Admitted On
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Admitted On',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                controller: TextEditingController(text: DateFormat('yyyy-MM-dd').format(_admittedOn)),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode()); // Remove focus from the text field
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _admittedOn,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != _admittedOn) {
                    setState(() {
                      _admittedOn = pickedDate;
                    });
                  }
                },
              ),
              SizedBox(height: 10),

              // RBS
              TextFormField(
                controller: _rbsController,
                decoration: InputDecoration(labelText: 'RBS', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter RBS' : null,
              ),
              SizedBox(height: 10),

              // Password
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                obscureText: true,
                validator: (value) => value == null || value.isEmpty ? 'Please enter password' : null,
              ),
              SizedBox(height: 10),

              // Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password', border: OutlineInputBorder()),
                obscureText: true,
                validator: (value) => value == null || value.isEmpty ? 'Please confirm password' : null,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Add Patient'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2DC2D7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
