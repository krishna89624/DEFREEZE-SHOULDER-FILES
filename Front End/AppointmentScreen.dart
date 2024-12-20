import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart'; // Import your config file for baseUrl
import 'history_screen.dart'; // Import the HistoryScreen

class AppointmentScreen extends StatefulWidget {
  final String patientId;
  final String doctorId;

  const AppointmentScreen({Key? key, required this.patientId, required this.doctorId}) : super(key: key);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  bool loading = true;
  Map<String, dynamic>? patientData;
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    fetchPatientData();
  }

  Future<void> fetchPatientData() async {
    final url = Uri.parse('${Config.selectAppointmentUrl}?patientId=${widget.patientId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          patientData = jsonDecode(response.body);
          loading = false;
        });
      } else {
        throw Exception('Failed to load patient data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() => loading = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) setState(() => selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? startTime : endTime,
    );
    if (picked != null) setState(() => isStartTime ? startTime = picked : endTime = picked);
  }

  Future<void> handleSend() async {
    if (patientData == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Patient data is missing')));
      return;
    }

    final appointmentDetails = {
      'doctorId': widget.doctorId,
      'doctorname': patientData!['doctorname'],
      'specialization': patientData!['specialization'],
      'experience': patientData!['experience'],
      'doctorImage': patientData!['doctorImage'],
      'patientId': patientData!['patientId'],
      'name': patientData!['name'],
      'patientCase': patientData!['patientCase'],
      'patientImage': patientData!['patientImage'],
      'date': DateFormat('yyyy-MM-dd').format(selectedDate),
      'start_time': startTime.format(context),
      'end_time': endTime.format(context),
      'status': 'pending',
    };

    final response = await http.post(
      Uri.parse(Config.doctorAppointmentUrl), // Adjust URL as necessary
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(appointmentDetails),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(responseData['error'] != null
            ? 'Failed to create appointment: ${responseData['error']}'
            : 'Appointment successfully created with ID: ${responseData['appointmentId']}'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create appointment')));
    }
  }

  void navigateToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(
          patientId: widget.patientId,
          doctorImage: patientData!['doctorImage'], // Pass doctorImage
          patientImage: patientData!['patientImage'], // Pass patientImage
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment'),
        backgroundColor: Color(0xFF2DC2D7),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: navigateToHistory, // Navigate to history screen
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (patientData != null) ...[
              Text('Patient Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2DC2D7))),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF2DC2D7), width: 2), // Add border color and width
                    ),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(patientData!['patientImage']),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Patient ID: ${patientData!['patientId']}', style: TextStyle(fontSize: 16)),
                        Text(
                          'Name: ${patientData!['name'].length > 12 ? '${patientData!['name'].substring(0, 12)}...' : patientData!['name']}',
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis, // Use ellipsis if text overflows
                        ),
                        Text(
                          'Case: ${patientData!['patientCase'].length > 12 ? '${patientData!['patientCase'].substring(0, 12)}...' : patientData!['patientCase']}',
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis, // Use ellipsis if text overflows
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Appointment Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2DC2D7))),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(5), boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 4, spreadRadius: 2),
                  ]),
                  child: Text('Select Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}', style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectTime(context, true),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(5), boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 4, spreadRadius: 2),
                  ]),
                  child: Text('Select Start Time: ${startTime.format(context)}', style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectTime(context, false),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(5), boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 4, spreadRadius: 2),
                  ]),
                  child: Text('Select End Time: ${endTime.format(context)}', style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleSend,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2DC2D7), // Use backgroundColor instead of primary
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                ),
                child: Text('Send', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
