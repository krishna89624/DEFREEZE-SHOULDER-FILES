import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'config.dart'; // Import your config file for baseUrl

class PatientWhatsApp extends StatefulWidget {
  final String patientId;

  const PatientWhatsApp({Key? key, required this.patientId}) : super(key: key);

  @override
  _PatientWhatsAppState createState() => _PatientWhatsAppState();
}

class _PatientWhatsAppState extends State<PatientWhatsApp> {
  bool isLoading = true;
  Map<String, dynamic>? patientData;

  @override
  void initState() {
    super.initState();
    fetchPatientData();
  }

  Future<void> fetchPatientData() async {
    final url = Uri.parse('${Config.baseUrl}/whatsapp.php?patientId=${widget.patientId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Fetched patient data: $data"); // Log the complete response

        // Ensure data is a Map and contains expected types
        if (data is Map<String, dynamic>) {
          setState(() {
            patientData = {
              'doctor_image': data['doctor_image'] is String ? data['doctor_image'] : '',
              'doctorId': data['doctorId'] is String ? data['doctorId'] : '',
              'doctorname': data['doctorname'] is String ? data['doctorname'] : '',
              'specialization': data['specialization'] is String ? data['specialization'] : '',
              'experience': data['experience'] is String ? data['experience'] : '',
              'doctor_phone': data['doctor_phone'] is String ? data['doctor_phone'] : '',
              'patient_name': data['patient_name'] is String ? data['patient_name'] : '',
              'patientId': data['patientId'] is String ? data['patientId'] : '',
              'patient_admittedOn': data['patient_admittedOn'] is String ? data['patient_admittedOn'] : '',
              'patient_case': data['patient_case'] is String ? data['patient_case'] : '',
            };
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void openWhatsApp() async {
    if (patientData == null || patientData!['doctor_phone'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No contact number provided')),
      );
      return;
    }

    String phoneNumber = patientData!['doctor_phone'];
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+91$phoneNumber'; // Replace with your country code
    }

    final message = '''Hello Dr. ${patientData!['doctorname']},
    
I am your patient ${patientData!['patient_name']} (Patient ID: ${patientData!['patientId']}). 

I was admitted on ${patientData!['patient_admittedOn']} and have been experiencing issues related to ${patientData!['patient_case']}. I have some questions regarding my condition.

Best regards,
${patientData!['patient_name']}''' ;

    final whatsappUrl = 'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}';

    try {
      print("Attempting to open WhatsApp with URL: $whatsappUrl"); // Debug log
      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WhatsApp is not installed on this device')),
        );
      }
    } catch (e) {
      print("Error launching WhatsApp: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to open WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 400 ? 14.0 : 16.0; // Adjust font size based on screen width

    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2DC2D7), Colors.cyanAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : patientData == null
          ? Center(
        child: Text('No data found for patient ID: ${widget.patientId}', style: TextStyle(fontSize: fontSize)),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 8, // Increased shadow for depth
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFF2DC2D7), // Change this to your desired border color
                          width: 3, // Change this to your desired border width
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: patientData!['doctor_image'] != null
                            ? NetworkImage(patientData!['doctor_image'])
                            : null,
                        backgroundColor: Color(0xFF2DC2D7),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Doctor ID: ${patientData!['doctorId'] ?? 'N/A'}',
                            style: TextStyle(fontSize: fontSize, color: Colors.black87),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            'Doctor Name: ${patientData!['doctorname'] ?? 'N/A'}',
                            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.black87),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            'Specialization: ${patientData!['specialization'] ?? 'N/A'}',
                            style: TextStyle(fontSize: fontSize, color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            'Experience: ${patientData!['experience'] ?? 'N/A'} years',
                            style: TextStyle(fontSize: fontSize, color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            patientData!['doctor_phone'] != null
                ? ElevatedButton.icon(
              onPressed: openWhatsApp,
              icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
              label: const Text('Chat', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
              ),
            )
                : const Text(
              'No contact number provided',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
