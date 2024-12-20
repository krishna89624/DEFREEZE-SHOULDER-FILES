import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'PatientDetailsScreen.dart';
import 'package:auto_size_text/auto_size_text.dart'; // Import AutoSizeText

class ViewPatientScreen extends StatefulWidget {
  @override
  _ViewPatientScreenState createState() => _ViewPatientScreenState();
}

class _ViewPatientScreenState extends State<ViewPatientScreen> with WidgetsBindingObserver {
  bool loading = false;
  String error = '';
  List patients = [];
  List filteredPatients = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPatientDetails();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchPatientDetails();
    }
  }

  Future<void> fetchPatientDetails() async {
    setState(() {
      loading = true;
      error = '';
    });
    try {
      final response = await http.get(Uri.parse(Config.viewpatientlistUrl));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            patients = data;
            filteredPatients = data;
            loading = false;
          });
        } else {
          setState(() {
            error = 'No data found';
            loading = false;
          });
        }
      } else {
        setState(() {
          error = 'Failed to load data';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching data: $e';
        loading = false;
      });
    }
  }

  void filterPatients(String query) {
    final results = patients.where((patient) {
      final name = patient['patientId'].toString().toLowerCase();
      final patientCase = patient['patientCase'].toString().toLowerCase();
      final searchLower = query.toLowerCase();
      return name.contains(searchLower) || patientCase.contains(searchLower);
    }).toList();

    setState(() {
      filteredPatients = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenPadding = screenWidth * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          'Patient Details',
          minFontSize: 14,
        ),
        backgroundColor: Color(0xFF2DC2D7),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenPadding, vertical: 16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by PatientId',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onChanged: filterPatients,
            ),
          ),
          loading
              ? Center(child: CircularProgressIndicator())
              : error.isNotEmpty
              ? Center(child: AutoSizeText(error, minFontSize: 14))
              : Expanded(
            child: ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF2DC2D7), width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              filteredPatients[index]['image'] ?? '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                'Patient ID: ${filteredPatients[index]['patientId'] ?? 'Unknown'}',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                minFontSize: 14,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              AutoSizeText(
                                'Name: ${filteredPatients[index]['name'] ?? 'Unknown'}',
                                style: TextStyle(fontSize: 14),
                                minFontSize: 14,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              AutoSizeText(
                                'Patient Case: ${filteredPatients[index]['patientCase'] ?? 'No case'}',
                                style: TextStyle(fontSize: 14),
                                minFontSize: 14,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              AutoSizeText(
                                'Admitted On: ${filteredPatients[index]['admittedOn'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 14),
                                minFontSize: 12,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2DC2D7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientDetailsScreen(
                                  image: filteredPatients[index]['image'] ?? '',
                                  patientId: filteredPatients[index]['patientId'] ?? '',
                                  name: filteredPatients[index]['name'] ?? '',
                                  contactNo: filteredPatients[index]['contactNo'] ?? '',
                                  age: int.tryParse(filteredPatients[index]['age'].toString()) ?? 0,
                                  gender: filteredPatients[index]['gender'] ?? '',
                                  height: double.tryParse(filteredPatients[index]['height'].toString()) ?? 0.0,
                                  weight: double.tryParse(filteredPatients[index]['weight'].toString()) ?? 0.0,
                                  patientCase: filteredPatients[index]['patientCase'] ?? '',
                                  painDuration: filteredPatients[index]['painDuration'] ?? '',
                                  admittedOn: filteredPatients[index]['admittedOn'] ?? '',
                                  rbs: (int.tryParse(filteredPatients[index]['rbs'].toString()) ?? 0).toDouble(),
                                  password: filteredPatients[index]['password'] ?? '',
                                  confirmPassword: filteredPatients[index]['confirmPassword'] ?? '',
                                  doctorId: filteredPatients[index]['doctorId'] ?? '',
                                ),
                              ),
                            ).then((_) {
                              fetchPatientDetails();
                            });
                          },
                          child: AutoSizeText(
                            'Show All Details',
                            minFontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
