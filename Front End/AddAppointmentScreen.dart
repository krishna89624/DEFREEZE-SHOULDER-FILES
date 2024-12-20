import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart'; // Import your config file for baseUrl
import 'HistoryScreen.dart'; // Import the HistoryScreen

class AddAppointmentScreen extends StatefulWidget {
  final String patientId;

  const AddAppointmentScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  bool loading = true;
  Map<String, dynamic>? patientData;
  DateTime date = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    fetchPatientData();
  }

  Future<void> fetchPatientData() async {
    final response = await http.get(Uri.parse('${Config.selectAppointment}?patientId=${widget.patientId}'));
    if (response.statusCode == 200) {
      setState(() {
        patientData = json.decode(response.body);
        loading = false;
      });
    } else {
      throw Exception('Failed to load patient data');
    }
  }

  Future<void> handleSend() async {
    final appointmentDetails = {
      'doctorId': patientData!['doctorId'],
      'doctorname': patientData!['doctorname'],
      'specialization': patientData!['specialization'],
      'experience': patientData!['experience'],
      'doctorImage': patientData!['doctorImage'],
      'patientId': patientData!['patientId'],
      'name': patientData!['name'],
      'patientCase': patientData!['patientCase'],
      'patientImage': patientData!['patientImage'],
      'date': DateFormat('yyyy-MM-dd').format(date),
      'time': '${startTime.format(context)} - ${endTime.format(context)}',
      'status': 'pending',
      'start_time': startTime.format(context),
      'end_time': endTime.format(context),
    };

    final response = await http.post(
      Uri.parse(Config.createAppointment), // Update with your endpoint
      headers: {'Content-Type': 'application/json'},
      body: json.encode(appointmentDetails),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment successfully created with ID: ${data['appointmentId']}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create appointment')),
      );
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != date) {
      setState(() {
        date = pickedDate;
      });
    }
  }

  Future<void> selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (pickedTime != null && pickedTime != startTime) {
      setState(() {
        startTime = pickedTime;
      });
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: endTime,
    );
    if (pickedTime != null && pickedTime != endTime) {
      setState(() {
        endTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment',overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
            maxLines: 1),
        backgroundColor: Color(0xFF2DC2D7),
        actions: [
          IconButton(
            icon: Icon(Icons.history), // Replace with your desired icon
            onPressed: () {
              // Navigate to the history screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryScreen(
                    patientId: patientData!['patientId'],
                    doctorImage: patientData!['doctorImage'],
                    patientImage: patientData!['patientImage'],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Doctor Details Section
            // Doctor Details Section
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Doctor Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFF2DC2D7), // Set your desired border color here
                              width: 3, // Set the border width
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(patientData!['doctorImage']),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Doctor Id: ${patientData!['doctorId']}', style: TextStyle(fontSize: 18),overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                                  maxLines: 1),
                              Text('Doctor Name: ${patientData!['doctorname']}', style: TextStyle(fontSize: 18) ,overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                                maxLines: 1),
                              Text('Specialization: ${patientData!['specialization']}', style: TextStyle(fontSize: 18),overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                                  maxLines: 1),
                              Text('Experience: ${patientData!['experience']} years', style: TextStyle(fontSize: 18),overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                                  maxLines: 1),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),


            SizedBox(height: 20),

            // Appointment Details Section
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Appointment Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => selectDate(context),
                      child: Text('Select Date: ${DateFormat('yMMMd').format(date)}'),
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2DC2D7)),
                    ),
                    ElevatedButton(
                      onPressed: () => selectStartTime(context),
                      child: Text('Select Start Time: ${startTime.format(context)}'),
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2DC2D7)),
                    ),
                    ElevatedButton(
                      onPressed: () => selectEndTime(context),
                      child: Text('Select End Time: ${endTime.format(context)}'),
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2DC2D7)),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Send Button
            ElevatedButton(
              onPressed: handleSend,
              child: Text('Send Appointment',overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                  maxLines: 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2DC2D7),
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 100),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
