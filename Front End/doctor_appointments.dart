import 'package:flutter/material.dart';
import 'dart:convert'; // For decoding JSON
import 'package:http/http.dart' as http; // For making HTTP requests
import 'config.dart';
class DoctorAppointments extends StatefulWidget {
  final List<dynamic> pendingAppointments;
  final String doctorId;
  final String doctorName; // New parameter
  final String doctorSpecialization; // New parameter

  const DoctorAppointments({
    Key? key,
    required this.pendingAppointments,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialization,
  }) : super(key: key);

  @override
  _DoctorAppointmentsState createState() => _DoctorAppointmentsState();
}

class _DoctorAppointmentsState extends State<DoctorAppointments> {
  late Future<List<dynamic>> _patientsFuture;
  bool _showAllPatients = false; // Control whether to show all patients or a limited list

  // Function to fetch patient details from the API
  Future<List<dynamic>> fetchPatients(String doctorId) async {
    final url = Uri.parse('${Config.baseUrl}/doctorlist.php?doctorId=$doctorId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);

      // Check if the response is a list
      if (jsonResponse is List) {
        return jsonResponse;
      } else {
        // If it's not a list, return an empty list or handle accordingly
        return [];
      }
    } else {
      throw Exception('Failed to load patients');
    }
  }


  @override
  void initState() {
    super.initState();
    _patientsFuture = fetchPatients(widget.doctorId); // Fetch patients when the widget is built
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container for Pending Appointments
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Pending Appointments',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Stack(
            children: [
              Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: widget.pendingAppointments.isEmpty
                    ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'No Pending Appointments',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                )
                    : Column(
                  children: [
                    Container(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.pendingAppointments.length > 4
                            ? 4
                            : widget.pendingAppointments.length,
                        itemBuilder: (context, index) {
                          var appointment = widget.pendingAppointments[widget.pendingAppointments.length - 1 - index];
                          return Container(
                            width: 150,

                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Card(
                              elevation: 4,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/DoctorAppointmentDetailScreen', // Update with your actual route name
                                    arguments: {
                                      'pendingAppointments': widget.pendingAppointments,
                                      'doctorId': widget.doctorId,
                                      'doctorName': widget.doctorName,
                                      'doctorSpecialization': widget.doctorSpecialization,
                                      'patientId': appointment['patientId'],
                                      'name': appointment['name'],
                                      'appointmentId': appointment['appointmentId'],
                                      'patientImage': appointment['patientImage'],
                                      'patientCase': appointment['patientCase'],
                                      'status': appointment['status'],
                                    },
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 2, // Set border width
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          appointment['patientImage'],
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      '${appointment['appointmentId']}',
                                      overflow: TextOverflow.ellipsis, // Add ellipsis if the text overflows
                                      maxLines: 1, // Restrict to a single line
                                    ),                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
              // Floating "View All" Button
              Positioned(
                right: 10,
                bottom: 10,
                child: ElevatedButton(
                  onPressed: () {
                    print('Navigating to AppointmentsScreen Doctor ID: ${widget.doctorId}');
                    Navigator.pushNamed(
                      context,
                      '/AppointmentsScreen',
                      arguments: {
                        'doctorId': widget.doctorId,
                      },
                    );
                  },
                  child: Text('View All'),
                ),
              ),
            ],
          ),

          // Patient List Header
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Patient List',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Fetch and display patient details
          FutureBuilder<List<dynamic>>(
            future: _patientsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Handle error
                return _buildNoPatientsFoundContainer('No patients found');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildNoPatientsFoundContainer('No patients found');
              } else {
                List<dynamic> patients = snapshot.data!;

                return Stack(
                  children: [
                    Container(
                      height: 380, // Adjust this value to increase the container height
                      margin: EdgeInsets.only(top: 2.0, left: 10.0, right: 10.0, bottom: 10.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded( // Allow the ListView to expand within the container
                            child: ListView.builder(
                              itemCount: _showAllPatients
                                  ? patients.length
                                  : (patients.length > 4 ? 4 : patients.length),
                              itemBuilder: (context, index) {
                                var patient = patients[index]; // Use patients list here
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 6.0), // Space between buttons
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white, // Border color
                                      width: 2, // Border width
                                    ),
                                    borderRadius: BorderRadius.circular(8.0), // Match the button's border radius
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(14.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      backgroundColor: Color(0xFF2DC2D7), // Button color
                                      elevation: 5, // Set elevation here
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/PatientFullDetScreen',
                                        arguments: {
                                          'doctorId': widget.doctorId,
                                          'patientId': patient['patientId'], // Pass patientId
                                          'doctorName': widget.doctorName, // Pass doctorName
                                          'doctorSpecialization': widget.doctorSpecialization, // Pass doctorSpecialization
                                          'patientImage': patient['image'], // Pass patientImage
                                        },
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Container for CircleAvatar with border
                                        Container(
                                          width: 50, // Set the width for the container
                                          height: 50, // Set the height for the container
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle, // Make it circular
                                            border: Border.all(
                                              color: Colors.white, // Border color
                                              width: 2, // Border width
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(patient['image']),
                                            radius: 25, // Radius for the CircleAvatar
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            'Patient ID: ${patient['patientId']}',
                                            style: TextStyle(color: Colors.white), // Text color
                                            overflow: TextOverflow.ellipsis, // This will add the ellipsis when text overflows
                                            maxLines: 1, // This will ensure the text stays in a single line
                                          ),

                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 15.0),
                        ],
                      ),
                    ),
                    // Floating "View All Patients" button
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/AllPatientsScreen',
                            arguments: {
                              'doctorId': widget.doctorId,
                              'doctorName': widget.doctorName,
                              'doctorSpecialization': widget.doctorSpecialization,
                            },
                          );
                        },
                        child: Text('View All Patients'),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoPatientsFoundContainer(String message) {
    return Container(
      height: 150, // Adjust the height as needed
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}
