import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class AllAppointmentsScreen extends StatefulWidget {
  final String patientId;
  final String? clickedAppointmentId;

  const AllAppointmentsScreen({Key? key, required this.patientId, this.clickedAppointmentId}) : super(key: key);

  @override
  _AllAppointmentsScreenState createState() => _AllAppointmentsScreenState();
}

class _AllAppointmentsScreenState extends State<AllAppointmentsScreen> with SingleTickerProviderStateMixin {
  List<dynamic> appointments = [];
  List<dynamic> filteredAppointments = [];
  bool loading = true;
  late TabController _tabController;
  String selectedTab = 'pending';
  String searchTerm = '';
  bool noMatches = false;

  int currentPage = 1;
  final int appointmentsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      fetchAppointments(['pending', 'accepted', 'rejected'][_tabController.index]);
    });

    fetchAppointments(selectedTab);
  }

  Future<void> fetchAppointments(String status) async {
    setState(() {
      loading = true;
      selectedTab = status;
      currentPage = 1;
    });

    try {
      final response = await http.get(Uri.parse('${Config.baseUrl}/appointment1.php?status=$status&patientId=${widget.patientId}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body).reversed.toList();
        if (widget.clickedAppointmentId != null) {
          var clickedAppointment = data.firstWhere((app) => app['appointmentId'] == widget.clickedAppointmentId, orElse: () => null);
          if (clickedAppointment != null) {
            appointments = [clickedAppointment] + data.where((app) => app['appointmentId'] != widget.clickedAppointmentId).toList();
          } else {
            appointments = data;
          }
        } else {
          appointments = data;
        }
        filterAppointments();
      } else {
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
      setState(() {
        noMatches = true;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void filterAppointments() {
    if (searchTerm.trim().isEmpty) {
      filteredAppointments = appointments;
      noMatches = false;
    } else {
      filteredAppointments = appointments.where((appointment) {
        return appointment['appointmentId'].toString().contains(searchTerm.trim()) ||
            appointment['doctorname'].toLowerCase().contains(searchTerm.trim().toLowerCase());
      }).toList();
      noMatches = filteredAppointments.isEmpty;
    }
  }

  void handleSearchChange(String text) {
    setState(() {
      searchTerm = text;
      filterAppointments();
    });
  }

  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/appointmentstatus1.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'appointmentId': appointmentId, 'status': status}),
      );

      final data = json.decode(response.body);
      if (data['success']) {
        fetchAppointments(selectedTab);
      } else {
        print('Error updating appointment: ${data['message']}');
      }
    } catch (e) {
      print('Error updating appointment: $e');
    }
  }

  Widget renderAppointment(Map<String, dynamic> item) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.04;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF2DC2D7), width: 2),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(item['doctorImage']),
                    radius: 40,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Appt ID: ${item['appointmentId']}',
                        style: TextStyle(fontSize: fontSize),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        'Doctor ID: ${item['doctorId']}',
                        style: TextStyle(fontSize: fontSize),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        'Status: ${item['status']}',
                        style: TextStyle(fontSize: fontSize, color: getStatusColor(item['status'])),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            buildStatusRow(item, fontSize),
          ],
        ),
      ),
    );
  }

  Widget buildStatusRow(Map<String, dynamic> appointment, double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (appointment['status'] == 'pending')
            DropdownButton<String>(
              hint: Text(
                'Change Status',
                style: TextStyle(fontSize: fontSize),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              value: null,
              items: ['accepted', 'rejected'].map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(
                    status,
                    style: TextStyle(fontSize: fontSize),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  updateAppointmentStatus(appointment['appointmentId'], newValue);
                }
              },
            ),
          TextButton(
            onPressed: () {
              _showAppointmentDetailsDialog(appointment);
            },
            child: Text(
              'View Details',
              style: TextStyle(fontSize: fontSize),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  void _showAppointmentDetailsDialog(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Appointment Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Appointment ID: ${appointment['appointmentId']}'),
                Text('Doctor ID: ${appointment['doctorId']}'),
                Text('Doctor Name: ${appointment['doctorname']}'),
                Text('Specialization: ${appointment['specialization']}'),
                Text('Experience: ${appointment['experience']} years'),
                Text('Status: ${appointment['status']}'),
                Text('Start Time: ${appointment['start_time']}'),
                Text('End Time: ${appointment['end_time']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('List Of Appointments'),
        backgroundColor: const Color(0xFF2DC2D7),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF2DC2D7),
              tabs: [
                Tab(text: 'Pending'),
                Tab(text: 'Accepted'),
                Tab(text: 'Rejected'),
              ],
              labelColor: const Color(0xFF2DC2D7),
              unselectedLabelColor: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search by Appointment ID or Doctor Name',
              ),
              onChanged: handleSearchChange,
            ),
          ),
          if (noMatches)
            Center(
              child: Text(
                'No matches found for "$searchTerm"',
                style: const TextStyle(color: Colors.red),
              ),
            )
          else
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildAppointmentList('pending'),
                  buildAppointmentList('accepted'),
                  buildAppointmentList('rejected'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget buildAppointmentList(String status) {
    return ListView.builder(
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        return renderAppointment(filteredAppointments[index]);
      },
    );
  }
}
