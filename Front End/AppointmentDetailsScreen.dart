import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart'; // Adjust the path as necessary

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({Key? key}) : super(key: key);

  Future<void> updateAppointmentStatus(BuildContext context, String appointmentId, String status) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/appointmentstatus1.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'appointmentId': appointmentId, 'status': status}),
      );

      final data = json.decode(response.body);
      if (data['success']) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Appointment status updated to "$status".'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to previous screen
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
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
          title: Text('Error'),
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

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final appointment = arguments['appointmentDetails'] as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
        backgroundColor: Color(0xFF2DC2D7),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to previous screen
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align items at the start
            children: [
              SizedBox(height: 16), // Space below the AppBar
              Card(
                elevation: 8, // Increased elevation for a more pronounced shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.55, // Adjusted height
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Align items at the start
                    crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                    children: [
                      // Image with border and rounded corners
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12), // More rounded corners
                          border: Border.all(color: Color(0xFF2DC2D7), width: 3), // Thicker border
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12), // Match border radius
                          child: Image.network(
                            appointment['doctorImage'] ?? '',
                            height: 150, // Increased height for better visibility
                            width: 150, // Increased width
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.person, size: 100, color: Color(0xFF2DC2D7));
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 15), // Reduced spacing
                      // Appointment details
                      Text(
                        'Appointment ID: ${appointment['appointmentId']}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2DC2D7)),
                        textAlign: TextAlign.center, // Center text
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // Ensure it fits in one line
                      ),
                      SizedBox(height: 4), // Reduced spacing
                      Text(
                        'Doctor ID: ${appointment['doctorId']}',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // Ensure it fits in one line
                      ),
                      SizedBox(height: 4), // Reduced spacing
                      Text(
                        'Doctor Name: ${appointment['doctorname']}',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // Ensure it fits in one line
                      ),
                      SizedBox(height: 4), // Reduced spacing
                      Text(
                        'Specialization: ${appointment['specialization']}',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // Ensure it fits in one line
                      ),
                      SizedBox(height: 4), // Reduced spacing
                      Text(
                        'Experience: ${appointment['experience']} years',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // Ensure it fits in one line
                      ),
                      SizedBox(height: 4), // Reduced spacing
                      Text(
                        'Date: ${appointment['date']}',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // Ensure it fits in one line
                      ),
                      SizedBox(height: 16), // Adjusted spacing before buttons
                      // Buttons for accepting or rejecting the appointment
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              updateAppointmentStatus(context, appointment['appointmentId'], 'accepted');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2DC2D7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12), // Adjusted padding
                            ),
                            child: Text('Accept', style: TextStyle(fontSize: 16)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              updateAppointmentStatus(context, appointment['appointmentId'], 'rejected');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12), // Adjusted padding
                            ),
                            child: Text('Reject', style: TextStyle(fontSize: 16)),
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
      ),
    );
  }
}
