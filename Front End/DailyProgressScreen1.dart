import 'package:flutter/material.dart';

class DailyProgressScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the arguments passed from the previous screen
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String doctorId = args?['doctorId'] ?? 'Unknown';
    final String patientId = args?['patientId'] ?? 'Unknown';
    final String doctorName = args?['doctorName'] ?? 'Unknown';
    final String doctorSpecialization = args?['doctorSpecialization'] ?? 'Unknown';
    final String patientImage = args?['patientImage'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Progress'),
        backgroundColor: Color(0xFF2DC2D7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: patientImage.isNotEmpty
                  ? NetworkImage(patientImage)
                  : AssetImage('assets/placeholder.png') as ImageProvider,
            ),
            SizedBox(height: 16),
            Text('Doctor: $doctorName', style: TextStyle(fontSize: 18)),
            Text('Specialization: $doctorSpecialization', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Patient ID: $patientId', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            // Add your daily progress tracking functionality here
            Text('Here you can track and update the patient\'s daily progress...'),
          ],
        ),
      ),
    );
  }
}
