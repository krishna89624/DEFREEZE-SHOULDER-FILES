import 'package:flutter/material.dart';

class QuestionnairesScreen extends StatelessWidget {
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
        title: Text('Patient Questionnaires'),
        backgroundColor: Color(0xFF2DC2D7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center( // Center the buttons in the screen
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/MedicalHistoryScreen', // Replace with your inquiry questions route
                    arguments: {
                      'doctorId': doctorId,
                      'patientId': patientId,
                      'doctorName': doctorName,
                      'doctorSpecialization': doctorSpecialization,
                      'patientImage': patientImage,
                    },
                  );
                },
                child: Text('Inquiry Questions'),
              ),
              SizedBox(height: 16), // Space between buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/weeklyQuestions', // Replace with your weekly questions route
                    arguments: {
                      'doctorId': doctorId,
                      'patientId': patientId,
                      'doctorName': doctorName,
                      'doctorSpecialization': doctorSpecialization,
                      'patientImage': patientImage,
                    },
                  );
                },
                child: Text('Weekly Questions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
