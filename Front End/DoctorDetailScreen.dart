import 'package:flutter/material.dart';
import 'package:defreeze_shoulder/EditDoctorScreen.dart';

class DoctorDetailScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const DoctorDetailScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  _DoctorDetailScreenState createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  late Map<String, dynamic> doctor;

  @override
  void initState() {
    super.initState();
    doctor = widget.doctor; // Initialize with passed data
    print(doctor); // Debugging step to print doctor data
  }

  @override
  void didUpdateWidget(covariant DoctorDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the doctor data has changed
    if (oldWidget.doctor != widget.doctor) {
      doctor = widget.doctor; // Update the local doctor data
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure that doctor data is valid before accessing it
    if (doctor is! Map<String, dynamic>) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Doctor Details"),
          backgroundColor: Color(0xFF2DC2D7),
        ),
        body: Center(
          child: Text("Invalid doctor data."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Doctor Details",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFF2DC2D7),
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshPage,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Doctor Profile Image with Border
              buildProfileImage(doctor['image'] ?? 'default_image_url'),
              SizedBox(height: 16.0),

              // Doctor's Basic Information
              buildDetailCard("Doctor Details", [
                buildInfoRow(Icons.person, "Name", doctor['doctorname'] ?? 'Not Available'),
                buildInfoRow(Icons.medical_services, "Specialization", doctor['specialization'] ?? 'Not Available'),
                buildInfoRow(Icons.badge, "ID", doctor['doctorId'] ?? 'Not Available'),
                buildInfoRow(Icons.phone, "Phone", doctor['phoneno'] ?? 'Not Available'),
                buildInfoRow(
                  doctor['gender'] == 'Male' ? Icons.male : Icons.female,
                  "Gender",
                  doctor['gender'] ?? 'Not Available',
                ),
                buildInfoRow(Icons.cake, "Age", doctor['age']?.toString() ?? 'Not Available'),
                buildInfoRow(
                    Icons.work, "Experience", "${doctor['experience'] ?? 'Not Available'} years"),
              ]),

              SizedBox(height: 16.0),

              // Password Section
              buildDetailCard("Password Information", [
                buildInfoRow(Icons.lock, "Password", doctor['password'] ?? 'Not Set'),
                buildInfoRow(Icons.lock_outline, "Confirm Password", doctor['confirmpassword'] ?? 'Not Set'),
              ]),

              SizedBox(height: 16.0),

              // Edit Button
              ElevatedButton(
                onPressed: () async {
                  final updatedDoctor = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDoctorScreen(doctor: doctor),
                    ),
                  );

                  // Check if updatedDoctor is not null
                  if (updatedDoctor != null) {
                    _refreshAllContents(updatedDoctor);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("No updates received.")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2DC2D7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'Edit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Refresh logic
  void _refreshPage() {
    setState(() {
      // You can add logic here to re-fetch the data or reset values if needed.
      doctor = widget.doctor;  // Resetting doctor data to initial state
      print("Page refreshed");
    });
  }

  void _refreshAllContents(Map<String, dynamic> updatedDoctor) {
    setState(() {
      doctor = updatedDoctor; // Update local doctor data
    });
  }

  Widget buildProfileImage(String imageUrl) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF2DC2D7), width: 3),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        radius: 60,
      ),
    );
  }

  Widget buildDetailCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2DC2D7),
              ),
            ),
            SizedBox(height: 8.0),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color(0xFF2DC2D7)), // Icon for each field
          SizedBox(width: 8.0), // Spacing between icon and label
          Text(
            "$label: ", // Label text
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight, // Align value text to the right
              child: Text(
                value, // Value text
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
