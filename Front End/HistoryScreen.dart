import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart'; // Import your config file for baseUrl

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
  String statusFilter = 'pending';
  String searchTerm = '';
  int currentPage = 0;
  final int appointmentsPerPage = 10;

  @override
  void initState() {
    super.initState();
    fetchAppointments(statusFilter);
  }

  Future<void> fetchAppointments(String status) async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse('${Config.baseUrl}/patienthistoryscreen.php?status=$status&patientId=${widget.patientId}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        setState(() {
          appointments = data.reversed.toList();
          filterAppointments(appointments);
          loading = false;
        });
      } else {
        setState(() {
          appointments = [];
          loading = false;
        });
      }
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  void filterAppointments(List<dynamic> appointmentsList) {
    List<dynamic> filtered = appointmentsList;
    if (searchTerm.isNotEmpty) {
      filtered = filtered.where((appointment) => appointment['appointmentId'].toString().contains(searchTerm)).toList();
    }
    setState(() {
      filteredAppointments = filtered;
      currentPage = 0;
    });
  }

  void handleSearchChange(String text) {
    setState(() {
      searchTerm = text;
    });
    filterAppointments(appointments);
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  // Show the detailed appointment dialog
  void showDetailsDialog(dynamic appointment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Appointment Details',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'Appointment ID: ${appointment['appointmentId']}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  'Doctor ID: ${appointment['doctorId']}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  'Doctor Name: ${appointment['doctorname']}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  'Specialization: ${appointment['specialization']}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  'Experience: ${appointment['experience']} years',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  'Start Time: ${appointment['start_time']}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  'End Time: ${appointment['end_time']}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  'Status: ${appointment['status']}',
                  style: TextStyle(color: getStatusColor(appointment['status'])),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    final paginatedAppointments = filteredAppointments.skip(currentPage * appointmentsPerPage).take(appointmentsPerPage).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor History'),
        backgroundColor: Color(0xFF2DC2D7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by Doctor ID or Appointment ID',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: handleSearchChange,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      statusFilter = 'pending';
                    });
                    fetchAppointments(statusFilter);
                  },
                  child: Text('Pending'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusFilter == 'pending' ? Color(0xFF2DC2D7) : Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      statusFilter = 'accepted';
                    });
                    fetchAppointments(statusFilter);
                  },
                  child: Text('Accepted'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusFilter == 'accepted' ? Color(0xFF2DC2D7) : Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      statusFilter = 'rejected';
                    });
                    fetchAppointments(statusFilter);
                  },
                  child: Text('Rejected'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusFilter == 'rejected' ? Color(0xFF2DC2D7) : Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            Expanded(
              child: paginatedAppointments.isEmpty
                  ? Center(child: Text('No appointments found'))
                  : ListView.builder(
                itemCount: paginatedAppointments.length,
                itemBuilder: (context, index) {
                  final item = paginatedAppointments[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFF2DC2D7), // Set your desired border color
                                width: 2, // Set the border width
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 30, // Increased size
                              backgroundImage: NetworkImage(widget.doctorImage),
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Appt ID: ${item['appointmentId']}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              Text(
                                'Doctor ID: ${item['doctorId']}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                'Status: ${item['status']}',
                                style: TextStyle(color: getStatusColor(item['status'])),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5), // Space between Doctor ID and View Details button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end, // Align to the right
                            children: [
                              ElevatedButton(
                                onPressed: () => showDetailsDialog(item), // Show details dialog on press
                                child: Text(
                                  'View Details',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF2DC2D7), // Customize button color
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 0 ? () => setState(() => currentPage--) : null,
                  child: Text('Previous'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                ElevatedButton(
                  onPressed: (currentPage + 1) * appointmentsPerPage < filteredAppointments.length ? () => setState(() => currentPage++) : null,
                  child: Text('Next'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
