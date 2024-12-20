import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart'; // Import your config file

class HistoryScreen extends StatefulWidget {
  final String patientId;
  final String doctorImage;
  final String patientImage;

  const HistoryScreen({
    Key? key,
    required this.patientId,
    required this.doctorImage,
    required this.patientImage,
  }) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> appointments = [];
  List<dynamic> filteredAppointments = [];
  bool loading = true;
  String searchTerm = '';
  bool noAppointments = false;
  bool noMatches = false;
  int currentPage = 1;
  final int itemsPerPage = 10;
  String statusFilter = 'pending';

  @override
  void initState() {
    super.initState();
    fetchAppointments(statusFilter);
  }

  Future<void> fetchAppointments(String status) async {
    setState(() {
      loading = true;
    });

    try {
      final String url = Config.getDoctorHistoryUrl(status, widget.patientId);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          appointments = data.reversed.toList();
          filteredAppointments = appointments;
          noAppointments = appointments.isEmpty;
          loading = false;
          noMatches = false;
        });
      } else {
        setState(() {
          appointments = [];
          filteredAppointments = [];
          noAppointments = true;
          loading = false;
        });
      }
    } catch (error) {
      print('Error fetching appointments: $error');
      setState(() {
        loading = false;
        noAppointments = true;
      });
    }
  }

  void filterAppointments() {
    setState(() {
      if (searchTerm.isNotEmpty) {
        filteredAppointments = appointments.where((appointment) {
          return (appointment['appointmentId']?.toString().contains(searchTerm) ?? false) ||
              (appointment['patientId']?.toString().contains(searchTerm) ?? false);
        }).toList();
        noMatches = filteredAppointments.isEmpty;
      } else {
        filteredAppointments = appointments;
        noMatches = false;
      }
      currentPage = 1;
    });
  }

  void handlePageChange(int newPage) {
    if (newPage > 0 && newPage <= (filteredAppointments.length / itemsPerPage).ceil()) {
      setState(() {
        currentPage = newPage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final paginatedData = filteredAppointments.skip((currentPage - 1) * itemsPerPage).take(itemsPerPage).toList();

    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor History'),
        backgroundColor: Color(0xFF2DC2D7),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Status buttons (Pending, Accepted, Rejected)
                buildStatusButton('Pending', screenWidth),
                buildStatusButton('Accepted', screenWidth),
                buildStatusButton('Rejected', screenWidth),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by Patient ID or Appointment ID',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(screenWidth * 0.03),
              ),
              onChanged: (text) {
                setState(() {
                  searchTerm = text;
                });
                filterAppointments();
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            if (noAppointments)
              Center(child: Text('No appointments found'))
            else if (noMatches)
              Center(child: Text('No matches found for "$searchTerm"'))
            else ...[
                Expanded(
                  child: ListView.builder(
                    itemCount: paginatedData.length,
                    itemBuilder: (context, index) {
                      final item = paginatedData[index];
                      return buildAppointmentCard(item, screenWidth, screenHeight);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => handlePageChange(currentPage - 1),
                      child: Text('Previous'),
                    ),
                    Text(
                      'Page $currentPage of ${(filteredAppointments.length / itemsPerPage).ceil()}',
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    ElevatedButton(
                      onPressed: () => handlePageChange(currentPage + 1),
                      child: Text('Next'),
                    ),
                  ],
                ),
              ],
          ],
        ),
      ),
    );
  }

  Widget buildStatusButton(String status, double screenWidth) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          statusFilter = status.toLowerCase();
        });
        fetchAppointments(statusFilter);
      },
      child: Text(status),
      style: ElevatedButton.styleFrom(
        backgroundColor: statusFilter == status.toLowerCase() ? Color(0xFF2DC2D7) : Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.02),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget buildAppointmentCard(dynamic item, double screenWidth, double screenHeight) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Image on the left
            buildImage(item, screenWidth),

            SizedBox(width: screenWidth * 0.04), // Spacing between image and details

            // Appointment Details on the right
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appointment ID: ${item['appointmentId']?.toString() ?? 'N/A'}',
                    style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Patient ID: ${item['patientId'] ?? 'N/A'}',
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                  Text(
                    'Status: ${item['status'] ?? 'N/A'}',
                    style: TextStyle(
                      color: getStatusColor(item['status'] ?? 'pending'),
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // Moving the button up by adjusting padding
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.005), // Adjust this value to move the button up/down
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () => showDetailsDialog(context, item),
                          child: Text('View Details', style: TextStyle(fontSize: screenWidth * 0.035)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(dynamic item, double screenWidth) {
    return Container(
      width: screenWidth * 0.15,
      height: screenWidth * 0.15,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xFF2DC2D7), width: 2),
        image: DecorationImage(
          image: NetworkImage(
            item['patientImage']?.isNotEmpty == true
                ? item['patientImage']
                : widget.patientImage.isNotEmpty
                ? widget.patientImage
                : 'https://example.com/placeholder.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void showDetailsDialog(BuildContext context, dynamic item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Appointment Details', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appointment ID: ${item['appointmentId'] ?? 'N/A'}'),
            Text('Patient ID: ${item['patientId'] ?? 'N/A'}'),
            Text('Name: ${item['name'] ?? 'N/A'}'),
            Text('Case: ${item['patientCase'] ?? 'N/A'}'),
            Text('Status: ${item['status'] ?? 'N/A'}'),
            Text('Date: ${item['date'] ?? 'N/A'}'),
            Text('Start Time: ${item['start_time'] ?? 'N/A'}'),
            Text('End Time: ${item['end_time'] ?? 'N/A'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
