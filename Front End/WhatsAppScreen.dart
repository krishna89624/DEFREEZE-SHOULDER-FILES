import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WhatsAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String patientId = args?['patientId'] ?? 'Unknown';
    final String image = args?['patientImage'] ?? '';
    final String contactNo = args?['contactNo'] ?? 'Unknown';
    final String name = args?['name'] ?? 'Unknown';
    final String doctorName = args?['doctorName'] ?? 'Unknown';
    final String doctorSpecialization = args?['doctorSpecialization'] ?? 'Unknown';

    void handleOpenWhatsApp() async {
      if (contactNo.isEmpty) {
        _showAlert(context, 'Error', 'No contact number provided');
        return;
      }

      String phoneNumber = contactNo.startsWith('+') ? contactNo : '+91$contactNo';
      String message =
          'Hello $name, I am your doctor. My name is Dr. $doctorName, and I specialize in $doctorSpecialization. Are you experiencing any problems?';

      final whatsappUrl = 'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}';
      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        _showAlert(context, 'Error', 'WhatsApp is not installed on this device.');
      }
    }

    // Truncate name if it's longer than 12 characters
    String displayName = name.length > 12 ? '${name.substring(0, 12)}...' : name;

    // Use MediaQuery to adapt to different screen sizes
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 400 ? 14.0 : 16.0; // Adjust font size based on screen width

    return Scaffold(
      appBar: AppBar(
        title: Text('WhatsApp Communication'),
        backgroundColor: Color(0xFF2DC2D7),
        elevation: 2,
      ),
      body: Container(
        color: Color(0xFFCDF5FD),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image with Border
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // CircleAvatar wrapped in a Container for border
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF2DC2D7), width: 3), // Border color and width
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: image.isNotEmpty
                          ? NetworkImage(image)
                          : AssetImage('assets/placeholder.png') as ImageProvider,
                    ),
                  ),
                  SizedBox(width: 20),
                  // Main Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patient ID: $patientId',
                          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600, color: Color(0xFF2DC2D7)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Name: $displayName', // Display the truncated name
                          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Phone Number: $contactNo',
                          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Chat on WhatsApp Button
            contactNo.isNotEmpty
                ? ElevatedButton.icon(
              onPressed: handleOpenWhatsApp,
              icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 24),
              label: Text(
                'Chat on WhatsApp',
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF25D366),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No contact number provided',
                style: TextStyle(color: Colors.grey, fontSize: fontSize),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Color(0xFF2DC2D7))),
          ),
        ],
      ),
    );
  }
}
