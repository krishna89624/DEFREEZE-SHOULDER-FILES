import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart'; // Import AutoSizeText
import 'header.dart'; // Adjust the import based on your header file location
import 'package:defreeze_shoulder/config.dart'; // Adjust the import based on your file structure
import 'DoctorDetailScreen.dart'; // Add this import at the top of your file

class viewDoctorScreen extends StatefulWidget {
  @override
  _viewDoctorScreenState createState() => _viewDoctorScreenState();
}

class _viewDoctorScreenState extends State<viewDoctorScreen> {
  List doctors = [];
  bool loading = true;
  String? error;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    setState(() {
      loading = true;
    });
    try {
      final response = await http.get(Uri.parse(Config.viewDoctorListUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          doctors = data['doctors'] ?? [];
          loading = false;
        });
      } else {
        setState(() {
          error = 'Error fetching data: ${response.statusCode}';
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

  void handleBack() {
    Navigator.pop(context);
  }

  void navigateToDetailScreen(Map doctor) async {
    await Navigator.pushNamed(
      context,
      '/DoctorDetailScreen',
      arguments: doctor, // Pass the doctor object as arguments
    );

    // After returning from the detail screen, refresh the list
    fetchDoctors();
  }

  // Function to get responsive font size
  double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (baseFontSize / 375); // 375 is considered a standard screen width (for example iPhone 8)
  }

  @override
  Widget build(BuildContext context) {
    final filteredDoctors = doctors.where((doctor) =>
        doctor['doctorId'].toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return WillPopScope(
      onWillPop: () async {
        fetchDoctors(); // Refresh doctors list when popping the screen
        return true; // Allow the pop
      },
      child: Scaffold(
        appBar: AppBar(
          title: AutoSizeText(
            "Doctors List",
            style: TextStyle(
              color: Colors.black,
              fontSize: getResponsiveFontSize(context, 18), // Responsive font size
            ),
            maxLines: 1,
            minFontSize: 16,
          ),
          backgroundColor: Color(0xFF2DC2D7),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: handleBack,
          ),
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    searchQuery = text;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search by DoctorId',
                  hintStyle: TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Color(0xFF2DC2D7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Color(0xFF2DC2D7)),
                  ),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF2DC2D7)),
                ),
              ),
            ),
            // Loading and error handling
            loading
                ? Center(child: CircularProgressIndicator())
                : error != null
                ? Center(
              child: AutoSizeText(
                error!,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: getResponsiveFontSize(context, 16),
                    fontWeight: FontWeight.bold),
                maxLines: 2,
                minFontSize: 14,
              ),
            )
                : filteredDoctors.isEmpty
                ? Center(
              child: AutoSizeText(
                "No doctors found",
                style: TextStyle(
                  fontSize: getResponsiveFontSize(context, 18),
                ),
                maxLines: 1,
                minFontSize: 16,
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = filteredDoctors[index];
                  return Card(
                    margin: EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: MediaQuery.of(context).size.width *
                            0.2,
                        height: MediaQuery.of(context).size.width *
                            0.2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF2DC2D7),
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(doctor['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: AutoSizeText(
                        doctor['doctorname'],
                        style: TextStyle(
                          fontSize:
                          getResponsiveFontSize(context, 18),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        minFontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            "ID: ${doctor['doctorId']}",
                            style: TextStyle(
                                fontSize:
                                getResponsiveFontSize(
                                    context, 14)),
                            maxLines: 1,
                            minFontSize: 12,
                            overflow: TextOverflow.ellipsis,
                          ),
                          AutoSizeText(
                            "Specialization: ${doctor['specialization']}",
                            style: TextStyle(
                                fontSize:
                                getResponsiveFontSize(
                                    context, 14)),
                            maxLines: 1,
                            minFontSize: 12,
                            overflow: TextOverflow.ellipsis,
                          ),
                          AutoSizeText(
                            "Experience: ${doctor['experience']} years",
                            style: TextStyle(
                                fontSize:
                                getResponsiveFontSize(
                                    context, 14)),
                            maxLines: 1,
                            minFontSize: 12,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () =>
                            navigateToDetailScreen(doctor),
                        child: AutoSizeText(
                          "View Details",
                          maxLines: 1,
                          minFontSize: 14,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2DC2D7),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
