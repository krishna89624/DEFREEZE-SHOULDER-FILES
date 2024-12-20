import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class AllPatientsScreen extends StatefulWidget {
  @override
  _AllPatientsScreenState createState() => _AllPatientsScreenState();
}

class _AllPatientsScreenState extends State<AllPatientsScreen> {
  late Future<List<dynamic>> _patientsFuture;
  late List<dynamic> _allPatients;
  late List<dynamic> _filteredPatients;
  late String doctorId;
  late String doctorName;
  late String doctorSpecialization;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      setState(() {
        doctorId = args['doctorId'];
        doctorName = args['doctorName'];
        doctorSpecialization = args['doctorSpecialization'];
      });

      _patientsFuture = fetchPatients(doctorId);
    });
  }

  Future<List<dynamic>> fetchPatients(String doctorId) async {
    final url = Uri.parse('${Config.baseUrl}/doctorlist.php?doctorId=$doctorId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);
      if (jsonResponse is List) {
        setState(() {
          _allPatients = jsonResponse;
          _filteredPatients = _allPatients;
        });
        return jsonResponse;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load patients');
    }
  }

  void _filterPatients(String query) {
    setState(() {
      searchQuery = query;
      _filteredPatients = _allPatients.where((patient) {
        final patientId = patient['patientId'].toString();
        return patientId.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (doctorName == null || doctorSpecialization == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('All Patients'),
          backgroundColor: Color(0xFF2DC2D7),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('All Patients'),
        backgroundColor: Color(0xFF2DC2D7),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) => _filterPatients(query),
              decoration: InputDecoration(
                labelText: 'Search by Patient ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _patientsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching patients'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No patients found'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredPatients.length,
                    itemBuilder: (context, index) {
                      var patient = _filteredPatients[index];
                      return Container(
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 8.0,
                              spreadRadius: 2.0,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Color(0xFF2DC2D7), width: 2.0),
                              ),
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(patient['image']),
                                onBackgroundImageError: (error, stackTrace) {},
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Patient ID: ${patient['patientId']}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,

                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Name: ${patient['name']}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Patient Case: ${patient['patientCase']}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2DC2D7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/PatientFullDetScreen',
                                  arguments: {
                                    'doctorId': doctorId,
                                    'patientId': patient['patientId'],
                                    'doctorName': doctorName,
                                    'doctorSpecialization': doctorSpecialization,
                                    'patientImage': patient['image'],
                                  },
                                );
                              },
                              child: Text('View Details'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
