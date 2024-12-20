import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class LoginOptions extends StatefulWidget {
  @override
  _LoginOptionsState createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  String? selectedRole;
  final List<String> roles = ['Admin', 'Doctor', 'Patient'];

  final TextEditingController adminIdController = TextEditingController();
  final TextEditingController doctorIdController = TextEditingController();
  final TextEditingController patientIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleLogin() async {
    if (selectedRole == 'Admin') {
      await handleAdminLogin();
    } else if (selectedRole == 'Doctor') {
      await handleDoctorLogin();
    } else if (selectedRole == 'Patient') {
      await handlePatientLogin();
    } else {
      showAlert('Error', 'Please select a valid role.');
    }
  }

  Future<void> handleAdminLogin() async {
    final adminId = adminIdController.text;
    final password = passwordController.text;

    if (adminId.isEmpty || password.isEmpty) {
      showAlert('Missing Information', 'Please enter both Admin ID and Password.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(Config.adminLoginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'adminId': adminId, 'password': password}),
      );

      if (response.statusCode != 200) throw Exception('Network response was not ok');
      final responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        Navigator.pushNamed(context, '/AdminDashboard');
      } else {
        showAlert('Login Failed', responseData['message'] ?? 'Invalid admin ID or password.');
      }
    } catch (error) {
      print('Error: $error');
      showAlert('Error', 'An error occurred while attempting to log in. Please try again later.');
    }
  }

  Future<void> handleDoctorLogin() async {
    final doctorId = doctorIdController.text;
    final password = passwordController.text;

    if (doctorId.isEmpty || password.isEmpty) {
      showAlert('Missing Information', 'Please enter your Doctor ID and Password.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(Config.doctorLoginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'doctorId': doctorId, 'password': password}),
      );

      if (response.statusCode != 200) throw Exception('Network response was not ok');
      final responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        Navigator.pushNamed(context, '/DoctorDashboard', arguments: {
          'doctorId': doctorId,
          'doctorName': responseData['doctorname'],
          'doctorImage': responseData['image'],
          'doctorSpecialization': responseData['specialization'],
        });
      } else {
        showAlert('Login Failed', responseData['message']);
      }
    } catch (error) {
      print('Error: $error');
      showAlert('Error', 'An error occurred while attempting to log in. Please try again later.');
    }
  }

  Future<void> handlePatientLogin() async {
    final patientId = patientIdController.text;
    final password = passwordController.text;

    if (patientId.isEmpty || password.isEmpty) {
      showAlert('Missing Information', 'Please enter your Patient ID and Password.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(Config.patientLoginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'patientId': patientId, 'password': password}),
      );

      if (response.statusCode != 200) throw Exception('Network response was not ok');
      final responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        final completionResponse = await http.get(Uri.parse(Config.checkCompletionUrl(patientId)));
        final completionData = jsonDecode(completionResponse.body);

        if (completionData['completed']) {
          Navigator.pushNamed(context, '/PatientDashboardScreen', arguments: {
            'name': responseData['name'],
            'patientId': patientId,
            'patientCase': responseData['patientCase'],
            'contactNo': responseData['contactNo'],
          });
        } else {
          Navigator.pushNamed(
            context,
            '/MyQuestionsScreen',
            arguments: {
              'name': responseData['name'],
              'patientId': patientId,
              'imageUri': responseData['imageUri'],
              'patientCase': responseData['patientCase'],
              'contactNo': responseData['contactNo'],
            },
          );
        }
      } else {
        showAlert('Login Failed', responseData['message']);
      }
    } catch (error) {
      print('Error: $error');
      showAlert('Error', 'An error occurred while attempting to log in. Please try again later.');
    }
  }

  void handleForgotPassword() {
    if (selectedRole == 'Doctor') {
      Navigator.pushNamed(context, '/DocSetPasswordScreen', arguments: {'role': 'doctor'});
    } else if (selectedRole == 'Patient') {
      Navigator.pushNamed(context, '/PatSetPasswordScreen', arguments: {'role': 'patient'});
    } else {
      showAlert('Error', 'Forgot password is only available for Doctor or Patient roles.');
    }
  }

  void showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2DC2D7),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome',  // Welcome text added here
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2DC2D7)),
              ),
              SizedBox(height: 20),  // Spacing between the text and dropdown
              Container(
                width: double.infinity, // Make the dropdown occupy the full width
                margin: EdgeInsets.only(bottom: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true, // Makes the dropdown button expand
                    value: selectedRole,
                    hint: Text('Select your role', style: TextStyle(color: Colors.grey[700])),
                    items: roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value;
                        adminIdController.clear();
                        doctorIdController.clear();
                        patientIdController.clear();
                        passwordController.clear();
                      });
                    },
                  ),
                ),
              ),
              if (selectedRole != null)
                Column(
                  children: [
                    TextField(
                      controller: selectedRole == 'Admin'
                          ? adminIdController
                          : selectedRole == 'Doctor'
                          ? doctorIdController
                          : patientIdController,
                      decoration: InputDecoration(
                        labelText: 'Enter ${selectedRole} ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Enter Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: handleLogin,
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2DC2D7),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                    if (selectedRole == 'Doctor' || selectedRole == 'Patient')
                      TextButton(
                        onPressed: handleForgotPassword,
                        child: Text('Forgot Password?'),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
