import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart'; // Import your config file for baseUrl

class AppointmentsScreen extends StatefulWidget {
  final String doctorId;

  const AppointmentsScreen({Key? key, required this.doctorId}) : super(key: key);

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<dynamic> appointments = [];
  List<dynamic> filteredAppointments = [];
  bool loading = true;
  String selectedTab = 'pending';
  String searchTerm = '';
  bool noMatches = false;

  // Pagination State
  int currentPage = 1;
  final int appointmentsPerPage = 10;

  @override
  void initState() {
    super.initState();
    if (widget.doctorId.isNotEmpty) {
      fetchAppointments(selectedTab); // Fetch appointments here
    }
  }

  void fetchAppointments(String status) async {
    setState(() => loading = true);

    final url = '${Config.baseUrl}/appointment.php?status=$status&doctorId=${widget.doctorId}';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          appointments = data.reversed.toList(); // Reverse the appointments
        } else if (data['appointments'] is List) {
          appointments = data['appointments'].reversed.toList(); // Reverse the appointments
        }
        filterAppointments(); // Filter appointments immediately after fetching
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void filterAppointments() {
    setState(() {
      if (searchTerm.trim().isEmpty) {
        filteredAppointments = appointments.skip((currentPage - 1) * appointmentsPerPage).take(appointmentsPerPage).toList();
        noMatches = false;
      } else {
        filteredAppointments = appointments
            .where((appointment) =>
        appointment['appointmentId'].toString().contains(searchTerm) ||
            appointment['name'].toLowerCase().contains(searchTerm.toLowerCase()))
            .skip((currentPage - 1) * appointmentsPerPage)
            .take(appointmentsPerPage)
            .toList();
        noMatches = filteredAppointments.isEmpty;
      }
    });
  }

  void updateAppointmentStatus(String appointmentId, String status) async {
    final url = Config.appointmentstatusUrl;
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'appointmentId': appointmentId, 'status': status}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        fetchAppointments(selectedTab);
      }
    }
  }

  void handleSearchChange(String text) {
    setState(() {
      searchTerm = text;
      filterAppointments();
    });
  }

  // Function to show details in a dialog
  void showAppointmentDetailsDialog(dynamic appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Appointment Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Patient Name: ${appointment['name']}'),
                Text('Case: ${appointment['patientCase']}'),
                Text('Status: ${appointment['status']}', style: _getStatusStyle(appointment['status'])),
                Text('Date: ${appointment['date']}'),
                Text('Start Time: ${appointment['start_time']}'),
                Text('End Time: ${appointment['end_time']}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Media query to adjust layout for different screen sizes
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth < 600 ? 16.0 : 24.0; // Adjust padding based on screen width
    double fontSize = screenWidth < 600 ? 14.0 : 16.0; // Adjust font size for smaller screens
    double buttonFontSize = screenWidth < 600 ? 12.0 : 16.0; // Adjust button font size for smaller screens

    return Scaffold(
      appBar: AppBar(
        title: Text('List of Appointments'),
        backgroundColor: Color(0xFF2DC2D7), // Primary color
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: Color(0xFF2DC2D7)))
          : Column(
        children: [
          Padding(
            padding: EdgeInsets.all(padding),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by Appointment ID or Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: handleSearchChange,
            ),
          ),
          _buildTabBar(fontSize),
          Expanded(
            child: noMatches
                ? Center(child: Text('No matches found for "$searchTerm"', style: TextStyle(fontSize: fontSize, color: Colors.grey)))
                : filteredAppointments.isEmpty
                ? Center(child: Text('No appointments available', style: TextStyle(fontSize: fontSize, color: Colors.grey)))
                : ListView.builder(
              itemCount: filteredAppointments.length,
              itemBuilder: (context, index) {
                final appointment = filteredAppointments[index];
                return _buildAppointmentItem(appointment, fontSize);
              },
            ),
          ),
          _buildPagination(buttonFontSize),
        ],
      ),
    );
  }

  Widget _buildTabBar(double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildTabButton('Pending', 'pending', fontSize),
        _buildTabButton('Accepted', 'accepted', fontSize),
        _buildTabButton('Rejected', 'rejected', fontSize),
      ],
    );
  }

  Widget _buildTabButton(String title, String tab, double fontSize) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedTab = tab;
          currentPage = 1;
          fetchAppointments(tab); // Fetch appointments based on the selected tab
        });
      },
      style: TextButton.styleFrom(
        backgroundColor: selectedTab == tab ? Color(0xFF2DC2D7) : Colors.transparent,
        foregroundColor: selectedTab == tab ? Colors.white : Colors.grey,
      ),
      child: Text(title, style: TextStyle(fontSize: fontSize)),
    );
  }

  Widget _buildAppointmentItem(dynamic appointment, double fontSize) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFF2DC2D7),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(appointment['patientImage']),
                radius: 35,
              ),
            ),
            title: Text(
              'Appt ID: ${appointment['appointmentId']}',
              style: TextStyle(fontSize: fontSize),
              overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
              maxLines: 1, // Limit text to one line
            ),
            subtitle: Text(
              'Patient ID: ${appointment['patientId']}',
              style: TextStyle(fontSize: fontSize),
              overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
              maxLines: 1, // Limit text to one line
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appointment['status'] == 'pending'
                    ? DropdownButton<String>(
                  hint: Text(
                    'Change Status',
                    style: TextStyle(fontSize: fontSize),
                    overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                    maxLines: 1, // Limit text to one line
                  ),
                  value: null,
                  items: <String>['accepted', 'rejected'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: fontSize),
                        overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                        maxLines: 1, // Limit text to one line
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      String status = newValue.toLowerCase();
                      updateAppointmentStatus(appointment['appointmentId'], status);
                    }
                  },
                )
                    : Container(),
                TextButton(
                  onPressed: () {
                    showAppointmentDetailsDialog(appointment);
                  },
                  child: Text(
                    'View Details',
                    style: TextStyle(fontSize: fontSize),
                    overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                    maxLines: 1, // Limit text to one line
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPagination(double buttonFontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // "Previous" Button
          TextButton(
            onPressed: currentPage > 1
                ? () {
              setState(() {
                currentPage--;
                filterAppointments(); // Reload the appointments for the previous page
              });
            }
                : null,
            child: Text(
              'Previous',
              style: TextStyle(
                fontSize: buttonFontSize,
                color: currentPage > 1 ? Colors.blue : Colors.grey, // Disable when at first page
              ),
            ),
          ),

          // Current Page Display
          Text(
            'Page $currentPage',
            style: TextStyle(fontSize: buttonFontSize),
          ),

          // "Next" Button
          TextButton(
            onPressed: filteredAppointments.length == appointmentsPerPage
                ? () {
              setState(() {
                currentPage++;
                filterAppointments(); // Reload the appointments for the next page
              });
            }
                : null,
            child: Text(
              'Next',
              style: TextStyle(
                fontSize: buttonFontSize,
                color: filteredAppointments.length == appointmentsPerPage
                    ? Colors.blue
                    : Colors.grey, // Disable when on the last page
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _getStatusStyle(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return TextStyle(color: Colors.orange);
      case 'accepted':
        return TextStyle(color: Colors.green);
      case 'rejected':
        return TextStyle(color: Colors.red);
      default:
        return TextStyle(color: Colors.black);
    }
  }
}
