import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart'; // Import your config file for baseUrl

class DocSetPasswordScreen extends StatefulWidget {
  @override
  _DocSetPasswordScreenState createState() => _DocSetPasswordScreenState();
}

class _DocSetPasswordScreenState extends State<DocSetPasswordScreen> {
  final TextEditingController doctorIdController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool isVerified = false;

  final double animationScaleStart = 1.0;
  final double animationScaleEnd = 0.6;
  double animationScale = 1.0;

  bool validatePhoneNumber(String phoneNo) {
    final RegExp regex = RegExp(r'^[0-9]{10}$');
    return regex.hasMatch(phoneNo);
  }

  bool validatePassword(String password) {
    final RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }

  void showAlert(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> handleVerify() async {
    String doctorId = doctorIdController.text.trim();
    String phoneNo = phoneNoController.text.trim();

    if (doctorId.isEmpty || !validatePhoneNumber(phoneNo)) {
      showAlert('Error', 'Please enter a valid Doctor ID and phone number.');
      return;
    }

    setState(() {
      isLoading = true;
      animationScale = animationScaleEnd;
    });

    try {
      final response = await http.post(
        Uri.parse(Config.doctorPasswordVerificationUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'doctorId': doctorId, 'phoneNo': phoneNo}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final jsonResponse = json.decode(response.body);

      if (jsonResponse['exists'] == true) { // Check for 'exists' key
        setState(() {
          isVerified = true; // Proceed to show password fields
        });
      } else {
        showAlert('Error', 'Doctor ID does not exist or is invalid.');
      }
    } catch (error) {
      showAlert('Error', 'An error occurred while verifying: $error');
    } finally {
      setState(() {
        isLoading = false;
        animationScale = animationScaleStart;
      });
    }
  }

  Future<void> handleUpdatePassword() async {
    String doctorId = doctorIdController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String phoneNo = phoneNoController.text.trim();

    if (doctorId.isEmpty) {
      showAlert('Error', 'Doctor ID is required.');
      return;
    }

    if (!validatePassword(password)) {
      showAlert(
          'Error', 'Password must be at least 8 characters long, contain at least one uppercase letter, one number, and the remaining letters in lowercase.');
      return;
    }

    if (password != confirmPassword) {
      showAlert('Error', 'Passwords do not match.');
      return;
    }

    final requestData = {
      'doctorId': doctorId,
      'password': password,
      'confirmPassword': confirmPassword,
      'phoneNo': phoneNo,
    };

    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.post(
        Uri.parse(Config.doctorPasswordUpdateUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      final jsonResponse = json.decode(response.body);

      if (jsonResponse['success']) {
        showAlert('Success', jsonResponse['message']);

        // Navigate to PatientDashboardScreen after showing success alert
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context); // Go back to the previous screen
          Navigator.of(context).pushNamed('/LoginOptions'); // Navigate to the PatientDashboard
        });
      } else {
        showAlert('Error', jsonResponse['error'] ?? 'Password update failed.');
      }
    } catch (error) {
      showAlert('Error', 'An error occurred while updating the password.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Doctor Password'),
        backgroundColor: Color(0xFF2DC2D7),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: doctorIdController,
              labelText: 'Doctor ID',
              icon: Icons.person,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: phoneNoController,
              labelText: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 30),
            Transform.scale(
              scale: animationScale,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleVerify,
                child: Text(isLoading ? "Verifying..." : "Verify"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2DC2D7),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            if (isVerified) ...[
              SizedBox(height: 30),
              _buildTextField(
                controller: passwordController,
                labelText: 'New Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: confirmPasswordController,
                labelText: 'Confirm Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : handleUpdatePassword,
                child: Text(isLoading ? "Updating..." : "Update Password"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2DC2D7),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    IconData? icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xFF2DC2D7)),
        labelText: labelText,
        labelStyle: TextStyle(color: Color(0xFF2DC2D7)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF2DC2D7)),
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      style: TextStyle(color: Colors.black),
    );
  }
}
