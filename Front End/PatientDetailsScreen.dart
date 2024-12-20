import 'package:flutter/material.dart';
import 'EditPatientScreen.dart';

class PatientDetailsScreen extends StatelessWidget {
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

  PatientDetailsScreen({
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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$name\'s Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFF2DC2D7),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Patient Profile Image with Shadow Effect
                  Container(
                    width: 130, // Adjusted size to include border
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFF2DC2D7), // Custom border color
                        width: 4, // Thickness of the border
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(image),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Patient Information Cards
                  _buildInfoCard('Patient Details', [
                    _buildInfoRow(Icons.person, "Name", name),
                    _buildInfoRow(Icons.phone, "Contact No", contactNo),
                    _buildInfoRow(Icons.cake, "Age", age.toString()),
                    _buildInfoRow(Icons.wc, "Gender", gender),
                    _buildInfoRow(Icons.height, "Height", '${height.toString()} cm'),
                    _buildInfoRow(Icons.monitor_weight, "Weight", '${weight.toString()} kg'),
                    _buildInfoRow(Icons.health_and_safety, "Patient Case", patientCase),
                  ]),

                  SizedBox(height: 16),

                  _buildInfoCard('Additional Information', [
                    _buildInfoRow(Icons.timelapse, "Pain Duration", painDuration),
                    _buildInfoRow(Icons.calendar_today, "Admitted On", admittedOn),
                    _buildInfoRow(Icons.bloodtype, "RBS", '$rbs mg/dL'),
                  ]),

                  SizedBox(height: 24),

                  // Edit Button with Enhanced Styling
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPatientScreen(
                            image: image,
                            patientId: patientId,
                            name: name,
                            contactNo: contactNo,
                            age: age,
                            gender: gender,
                            height: height,
                            weight: weight,
                            patientCase: patientCase,
                            painDuration: painDuration,
                            admittedOn: admittedOn,
                            rbs: rbs,
                            password: password,
                            confirmPassword: confirmPassword,
                            doctorId: doctorId,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: Color(0xFF2DC2D7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: Icon(Icons.edit, color: Colors.black),
                    label: Text(
                      'Edit Patient Details',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2DC2D7),
              ),
            ),
            SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF2DC2D7)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          // Handle text overflow here
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              overflow: TextOverflow.ellipsis,  // Add this to handle overflow
              maxLines: 1, // Optional: to ensure the text doesn't wrap
            ),
          ),
        ],
      ),
    );
  }
}
