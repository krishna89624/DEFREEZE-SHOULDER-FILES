import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class PatSetPasswordScreen extends StatefulWidget {
  @override
  _PatSetPasswordScreenState createState() => _PatSetPasswordScreenState();
}

class _PatSetPasswordScreenState extends State<PatSetPasswordScreen> {
  final TextEditingController patientIdController = TextEditingController();
  final TextEditingController contactNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String doctorId = '';
  List<dynamic> doctorDetails = [];
  bool isLoading = false;

  Future<void> fetchDoctorDetails() async {
    String patientId = patientIdController.text;
    String contactNo = contactNoController.text;

    if (patientId.isEmpty || contactNo.isEmpty) {
      showErrorDialog('Both Patient ID and Contact Number are required.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(Config.patientPasswordUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'patientId': patientId, 'contactNo': contactNo}),
      );

      final jsonResponse = json.decode(response.body);
      if (jsonResponse['doctorDetails'].isNotEmpty) {
        setState(() {
          doctorDetails = jsonResponse['doctorDetails'];
        });
      } else {
        showErrorDialog(jsonResponse['error']);
      }
    } catch (error) {
      showErrorDialog('An error occurred while fetching doctor details.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool validatePassword(String password) {
    final minLength = 8;
    final hasCapitalLetter = RegExp(r'[A-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(password);

    return password.length >= minLength && hasCapitalLetter && hasNumber && hasLowerCase;
  }

  Future<void> handlePatSetPasswordScreen() async {
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      showErrorDialog('Passwords do not match.');
      return;
    }

    if (!validatePassword(password)) {
      showErrorDialog('Password must be at least 8 characters long, contain one capital letter, one number, and the remaining characters in small letters.');
      return;
    }

    final requestData = {
      'patientId': patientIdController.text,
      'doctorId': doctorId,
      'password': password,
      'confirmPassword': confirmPassword,
      'updatePassword': true,
    };

    try {
      final response = await http.post(
        Uri.parse(Config.patSetPasswordScreenUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      final jsonResponse = json.decode(response.body);
      print("Server response: $jsonResponse");

      if (jsonResponse['success']) {
        showSuccessDialog(jsonResponse['message'].isNotEmpty ? jsonResponse['message'] : 'Password updated successfully.');
      } else {
        showErrorDialog(jsonResponse['error'].isNotEmpty ? jsonResponse['error'] : 'An unknown error occurred.');
      }
    } catch (error) {
      print('Error occurred: $error');
      showErrorDialog('An error occurred while updating the password.');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // Set a base font size and scale it
    double baseFontSize = MediaQuery.of(context).size.width * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Password',
          style: TextStyle(fontSize: baseFontSize * 1.1), // Responsive font size
        ),
        backgroundColor: Color(0xFF2DC2D7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: patientIdController,
              decoration: InputDecoration(
                labelText: 'Patient ID',
                labelStyle: TextStyle(color: Color(0xFF2DC2D7), fontSize: baseFontSize),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2DC2D7)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2DC2D7), width: 2),
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: contactNoController,
              decoration: InputDecoration(
                labelText: 'Contact Number',
                labelStyle: TextStyle(color: Color(0xFF2DC2D7), fontSize: baseFontSize),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2DC2D7)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2DC2D7), width: 2),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Button background color is white
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Color(0xFF2DC2D7)), // Border color
                ),
                padding: EdgeInsets.symmetric(vertical: 15), // Padding for the button itself
              ),
              onPressed: isLoading ? null : fetchDoctorDetails,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20), // Padding for the text
                child: Text(
                  isLoading ? 'Loading...' : 'Fetch Doctor Details',
                  style: TextStyle(color: Color(0xFF2DC2D7), fontSize: baseFontSize * 0.9), // Text color
                ),
              ),
            ),

            SizedBox(height: 20),
            if (doctorDetails.isNotEmpty) ...[
              DropdownButton<String>(
                value: doctorId.isEmpty ? null : doctorId,
                hint: Text('Select Doctor', style: TextStyle(fontSize: baseFontSize)),
                items: doctorDetails.map<DropdownMenuItem<String>>((detail) {
                  return DropdownMenuItem<String>(
                    value: detail['doctorId'],
                    child: Text(detail['doctorId'], style: TextStyle(fontSize: baseFontSize)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    doctorId = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(color: Color(0xFF2DC2D7), fontSize: baseFontSize),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2DC2D7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2DC2D7), width: 2),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 15),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Color(0xFF2DC2D7), fontSize: baseFontSize),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2DC2D7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2DC2D7), width: 2),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Button background color is white
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Color(0xFF2DC2D7)), // Border color
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15), // Padding for the button itself
                ),
                onPressed: handlePatSetPasswordScreen,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20), // Padding for the text
                  child: Text(
                    'Update Password',
                    style: TextStyle(color: Color(0xFF2DC2D7), fontSize: baseFontSize * 0.9), // Text color
                  ),
                ),
              ),

            ],
          ],
        ),
      ),
    );
  }
}