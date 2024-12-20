import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'DownloadScreen.dart'; // Import the DownloadScreen

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Adjust the height
        child: AppBar(
          title: Text(
            'Admin Dashboard', // Title for your dashboard
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF2DC2D7), // Set header color
          actions: [
            IconButton(
              icon: Icon(Icons.download), // Download icon
              onPressed: () {
                // Navigate to the DownloadScreen when the download icon is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DownloadScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 140),
            _buildBox(
              context,
              'View Doctor',
              'assets/medical.png',
                  () {
                Navigator.pushNamed(context, '/viewDoctorScreen');
              },
                  () {
                Navigator.pushNamed(context, '/AddDoctorScreen');
              },
            ),
            SizedBox(height: 90),
            _buildBox(
              context,
              'View Patient',
              'assets/crowd.png',
                  () {
                Navigator.pushNamed(context, '/ViewPatientScreen');
              },
                  () {
                Navigator.pushNamed(context, '/AddPatientScreen');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBox(BuildContext context, String label, String imagePath, VoidCallback onViewPress, VoidCallback onAddPress) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.09), // 9% of screen width for margin
      padding: EdgeInsets.all(screenWidth * 0.08), // 8% of screen width for padding
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onViewPress,
            child: Image.asset(
              imagePath,
              width: screenWidth * 0.3,  // 30% of screen width for image size
              height: screenWidth * 0.3, // Keep the image square
            ),
          ),
          SizedBox(height: screenHeight * 0.02), // 2% of screen height for spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: screenWidth * 0.045, // Responsive font size
                  color: Colors.black,
                ),
              ),
              SizedBox(width: screenWidth * 0.03), // 3% of screen width for spacing
              GestureDetector(
                onTap: onAddPress,
                child: FaIcon(
                  FontAwesomeIcons.userPlus,
                  size: screenWidth * 0.06, // Responsive icon size
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
