import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart'; // Adjust the path as necessary

class DoctorAppointmentDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    String doctorId = args['doctorId'];
    String doctorName = args['doctorName'];
    String doctorSpecialization = args['doctorSpecialization'];
    String patientId = args['patientId'];
    String name = args['name'];
    String appointmentId = args['appointmentId'];
    String patientImage = args['patientImage'];
    String patientCase = args['patientCase'];
    String status = args['status'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient ID: $patientId'), // Displaying patientId in the title
        backgroundColor: Color(0xFF2DC2D7), // AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4, // Shadow for the card
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF2DC2D7), width: 2), // Border color and width
                        borderRadius: BorderRadius.circular(10.0), // Rounded corners
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          patientImage,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Patient Name: $name',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2DC2D7)),
                      overflow: TextOverflow.ellipsis, // Handle text overflow
                      maxLines: 1, // Limit text to one line
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Appointment ID: $appointmentId',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                      overflow: TextOverflow.ellipsis, // Handle text overflow
                      maxLines: 1, // Limit text to one line
                    ),
                    SizedBox(height: 8),

                    Text(
                      'Patient ID: $patientId',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      overflow: TextOverflow.ellipsis, // Handle text overflow
                      maxLines: 1, // Limit text to one line
                    ),
                    SizedBox(height: 8),

                    Text(
                      'Patient Case: $patientCase',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      overflow: TextOverflow.ellipsis, // Handle text overflow
                      maxLines: 1, // Limit text to one line
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Status: $status',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      overflow: TextOverflow.ellipsis, // Handle text overflow
                      maxLines: 1, // Limit text to one line
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => updateAppointmentStatus(context, appointmentId, 'accepted'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2DC2D7), // Accept button color
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Rounded corners
                          ),
                          child: Text('Accept', style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          onPressed: () => updateAppointmentStatus(context, appointmentId, 'rejected'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Reject button color
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Rounded corners
                          ),
                          child: Text('Reject', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateAppointmentStatus(BuildContext context, String appointmentId, String status) async {
    final url = Config.appointmentstatusUrl;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'appointmentId': appointmentId, 'status': status}),
      );

      final data = json.decode(response.body);
      if (data['success'] == true) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success', style: TextStyle(color: Color(0xFF2DC2D7))),
            content: Text('Appointment status updated to "$status".'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to previous screen
                },
                child: Text('OK', style: TextStyle(color: Color(0xFF2DC2D7))),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error', style: TextStyle(color: Colors.red)),
            content: Text('Failed to update appointment: ${data['message']}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error updating appointment: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error', style: TextStyle(color: Colors.red)),
          content: Text('An error occurred while updating the appointment.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
