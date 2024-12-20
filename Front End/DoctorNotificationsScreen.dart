import 'package:flutter/material.dart';
import 'config.dart'; // Import your config file for API endpoint
import 'dart:convert'; // For decoding JSON responses
import 'package:http/http.dart' as http; // Use http package for fetching data

class DoctorNotificationsScreen extends StatefulWidget {
  @override
  _DoctorNotificationsScreenState createState() => _DoctorNotificationsScreenState();
}

class _DoctorNotificationsScreenState extends State<DoctorNotificationsScreen> {
  List<String> _notifications = []; // Changed to List<String> to store messages
  String? doctorId;

  @override
  void initState() {
    super.initState();
    // No need to fetch notifications here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access ModalRoute here to get the doctorId
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    doctorId = args['doctorId'];
    _fetchNotifications(); // Fetch notifications after dependencies are resolved
  }

  // Fetch notifications from the server using the doctorId
  void _fetchNotifications() async {
    try {
      final response = await http.get(Uri.parse("${Config.getNotificationsUrl}?doctorId=$doctorId"));
      if (response.statusCode == 200) {
        // Print the response body for debugging
        print('Response body: ${response.body}');

        // Decode the response and extract messages
        var data = json.decode(response.body);
        setState(() {
          _notifications = List<String>.from(data['messages'] ?? []); // Use messages instead of notifications
        });
      } else {
        print('Failed to load notifications: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF2DC2D7),
      ),
      body: _notifications.isEmpty
          ? Center(child: Text('No notifications available', style: TextStyle(fontSize: 18, color: Colors.grey[600])))
          : ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index]; // Each item is now a message
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16), // Add padding for ListTile content
              leading: Icon(Icons.notification_important, color: Color(0xFF2DC2D7), size: 36), // Larger icon
              title: Text(notification, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Text(
                'Tap for details',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              onTap: () {
                // Handle notification tap, e.g., navigate to details
              },
            ),
          );
        },
      ),
    );
  }
}
