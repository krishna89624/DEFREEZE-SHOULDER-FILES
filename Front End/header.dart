import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For icons

class Header extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPress;
  final VoidCallback? onReportPress;
  final bool showReportButton;
  final bool showHistoryButton;
  final bool showPatientHistoryButton;
  final String? patientId;
  final String? doctorImage;
  final String? patientImage;

  const Header({
    required this.title,
    this.onBackPress,
    this.onReportPress,
    this.showReportButton = false,
    this.showHistoryButton = false,
    this.showPatientHistoryButton = false,
    this.patientId,
    this.doctorImage,
    this.patientImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      color: Color(0xFF2DC2D7), // Header background color
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: onBackPress ?? () => Navigator.pop(context),
              ),
              SizedBox(width: 10), // Add spacing between icon and text
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          if (showReportButton)
            TextButton(
              onPressed: onReportPress,
              child: Text(
                'Report',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          if (showHistoryButton || showPatientHistoryButton)
            IconButton(
              icon: Icon(FontAwesomeIcons.userFriends, color: Colors.black),
              onPressed: () {
                if (showHistoryButton) {
                  Navigator.pushNamed(context, '/doctorHistoryScreen', arguments: {
                    'patientId': patientId,
                    'doctorImage': doctorImage,
                    'patientImage': patientImage,
                  });
                } else if (showPatientHistoryButton) {
                  Navigator.pushNamed(context, '/patientHistoryScreen', arguments: {
                    'patientId': patientId,
                    'doctorImage': doctorImage,
                    'patientImage': patientImage,
                  });
                }
              },
            ),
        ],
      ),
    );
  }
}
