import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart'; // Add your configuration here

class PatientNotificationScreen extends StatefulWidget {
  @override
  _PatientNotificationScreenState createState() => _PatientNotificationScreenState();
}

class _PatientNotificationScreenState extends State<PatientNotificationScreen> {
  late String patientId;
  int notificationCount = 0;
  List<String> notifications = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    patientId = args['patientId'];
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final response = await http.get(Uri.parse('${Config.baseUrl}/get_notifications_patient.php?patientId=$patientId'));

      // Log the response body
      print('Response body: ${response.body}'); // Print the raw response

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          notificationCount = data['notification_count'];
          notifications = List<String>.from(data['messages']);
        });
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (error) {
      print('Error fetching notifications: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF2DC2D7), // Set app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the body
        child: notificationCount > 0
            ? ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return Card( // Use Card for each notification item
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 2,
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0), // Add padding inside the ListTile
                title: Text(
                  notifications[index],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), // Style text
                ),
              ),
            );
          },
        )
            : Center(
          child: Text(
            'No notifications for patient: $patientId',
            style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey), // Style message
          ),
        ),
      ),
    );
  }
}
