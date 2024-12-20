import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;
import 'config.dart'; // Import the config file
import 'EditPatientProfileScreen.dart'; // Import the edit screen

class PatientProfileScreen extends StatefulWidget {
  final String patientId;

  PatientProfileScreen({required this.patientId});

  @override
  _PatientProfileScreenState createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  Map<String, dynamic>? patientDetails;
  bool isLoading = true;
  String? errorMessage;
  bool isPasswordVisible = false; // Manage password visibility

  @override
  void initState() {
    super.initState();
    fetchPatientDetails();
  }

  Future<void> fetchPatientDetails() async {
    try {
      final response = await http.get(Uri.parse('${Config.baseUrl}/patientprofile1.php?patientId=${widget.patientId}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          patientDetails = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch patient details');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery for responsive design
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Align items to the start
          children: [
            SizedBox(width: 8), // Small space between the icon and the title
            Text(
              'Profile for Patient: ${widget.patientId}',
              style: TextStyle(
                fontSize: 20, // Adjust font size if necessary
                fontWeight: FontWeight.bold, // Make title bold
              ),
            ),
          ],
        ),
        centerTitle: false, // Set to false as we are managing the title alignment ourselves
        backgroundColor: Color(0xFF2DC2D7), // Custom color
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text('Error: $errorMessage', style: TextStyle(color: Colors.red, fontSize: 16)))
          : patientDetails != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient image with circular shape
              if (patientDetails!['imageUri'] != null)
                Center(
                  child: Container(
                    width: 120, // Set a width for the circular profile image
                    height: 120, // Set a height for the circular profile image
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Make the container circular
                      border: Border.all(
                        color: Color(0xFF2DC2D7),
                        width: 3,
                      ), // Border color and width
                    ),
                    child: ClipOval(
                      child: Image.network(
                        patientDetails!['imageUri'],
                        fit: BoxFit.cover, // Cover the entire circular area
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 20),

              Text('Patient Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2DC2D7))),
              SizedBox(height: 10),
              Divider(thickness: 2, color: Colors.grey[300]), // Divider line
              SizedBox(height: 20),
              _buildDetailRow('Name:', patientDetails!['name']),
              _buildDetailRow('Contact No:', patientDetails!['contactNo']),
              _buildDetailRow('Gender:', patientDetails!['gender']),
              _buildDetailRow('Age:', patientDetails!['age']),
              _buildDetailRow('Height:', '${patientDetails!['height']} cm'),
              _buildDetailRow('Weight:', '${patientDetails!['weight']} kg'),
              _buildDetailRow('Pain Duration:', patientDetails!['painDuration']),
              _buildDetailRow('Patient Case:', patientDetails!['patientCase']),
              _buildDetailRow('Admitted On:', patientDetails!['admittedOn']),
              _buildDetailRow('RBS:', '${patientDetails!['rbs']} mg/dL'),
              _buildDetailRow('Doctor ID:', patientDetails!['doctorId']),

              // Displaying password fields with visibility toggle
              SizedBox(height: 20),
              Text('Security Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2DC2D7))),
              SizedBox(height: 10),
              Divider(thickness: 2, color: Colors.grey[300]), // Divider line
              SizedBox(height: 20),
              _buildPasswordRow('Password:', patientDetails!['password']), // Assuming password is fetched from the API

              // Edit button
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2DC2D7),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded button corners
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPatientProfileScreen(
                          patientDetails: patientDetails!,
                          doctorId: patientDetails!['doctorId'], // Pass doctorId
                          image: patientDetails!['imageUri'], // Pass image
                          patientId: widget.patientId, // Pass patientId
                        ),
                      ),
                    ).then((_) {
                      Navigator.pop(context); // Navigate back after successful update
                    });
                  },
                  child: Text('Edit Profile', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      )
          : Center(child: Text('No patient details found')),
    );
  }

  Widget _buildDetailRow(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Use text overflow and maxLines for responsiveness
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Expanded(
            child: Text(
              detail,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRow(String title, String password) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Row(
            children: [
              Text(isPasswordVisible ? password : '●●●●●●●●●●●●', style: TextStyle(fontSize: 16)),
              IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible; // Toggle visibility
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
