import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'EditDoctorProfileScreen.dart';

class DoctorProfileScreen extends StatefulWidget {
  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  String doctorId = '';
  String doctorName = '';
  String doctorImage = '';
  String doctorSpecialization = '';
  String doctorPhone = '';
  String doctorGender = '';
  String doctorAge = '';
  String doctorExperience = '';
  String doctorPassword = '';
  String doctorConfirmPassword = '';
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    doctorId = args['doctorId'];
    fetchDoctorDetails();
  }

  Future<void> fetchDoctorDetails() async {
    try {
      final url = '${Config.baseUrl}/doctorsprofilescrren.php?doctorId=$doctorId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          doctorName = data['doctorname'] ?? 'Unknown Doctor';
          doctorImage = data['image'] != null ? '${Config.baseUrl}/${data['image']}' : 'default_image_url';
          doctorSpecialization = data['specialization'] ?? 'Specialization not provided';
          doctorPhone = data['phoneno'] ?? 'N/A';
          doctorGender = data['gender'] ?? 'N/A';
          doctorAge = data['age']?.toString() ?? 'N/A';
          doctorExperience = data['experience']?.toString() ?? 'N/A';
          doctorPassword = data['password'] ?? 'N/A';
          doctorConfirmPassword = data['confirmpassword'] ?? 'N/A';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Profile'),
        backgroundColor: Color(0xFF2DC2D7),
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFF2DC2D7),
                    width: 4.0,
                  ),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(doctorImage),
                ),
              ),
              SizedBox(height: 16),
              Text(
                doctorName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Set text color to black
                ),
              ),
              SizedBox(height: 8),
              SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildProfileDetail('Doctor ID', doctorId),
                    _buildProfileDetail('Phone', doctorPhone),
                    _buildProfileDetail('Gender', doctorGender),
                    _buildProfileDetail('Age', doctorAge),
                    _buildProfileDetail('Specialization', doctorSpecialization),
                    _buildProfileDetail('Experience', '$doctorExperience years'),
                    _buildProfileDetail('Password', doctorPassword),
                    _buildProfileDetail('Confirm Password', doctorConfirmPassword),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDoctorProfileScreen(
                        doctorId: doctorId,
                        doctorName: doctorName,
                        doctorSpecialization: doctorSpecialization,
                        doctorPhone: doctorPhone,
                        doctorGender: doctorGender,
                        doctorAge: doctorAge,
                        doctorExperience: doctorExperience,
                        doctorPassword: doctorPassword,
                        doctorConfirmPassword: doctorConfirmPassword,
                        doctorImage: doctorImage,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF2DC2D7),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Edit Profile', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2DC2D7))),
        subtitle: Text(
          value,
          style: TextStyle(color: Colors.black87),
          overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
          maxLines: 1, // Limit text to one line
        ),
        leading: Icon(Icons.info, color: Color(0xFF2DC2D7)),
      ),
    );
  }
}
