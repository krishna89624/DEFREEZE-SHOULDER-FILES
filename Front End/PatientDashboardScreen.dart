import 'dart:async';
import 'package:flutter/material.dart';
import 'config.dart'; // Add your configuration here
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'PendingAppointmentsWidget.dart'; // Import the separate widget file
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PatientDashboardScreen extends StatefulWidget {
  final String name;
  final String patientId;
  final String patientCase;
  final String contactNo;

  PatientDashboardScreen({
    Key? key,
    required this.name,
    required this.patientId,
    required this.patientCase,
    required this.contactNo,
  }) : super(key: key);

  @override
  _PatientDashboardScreenState createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
  String _profileImage = '';
  int _notificationCount = 0;
  List<dynamic> _pendingAppointments = [];
  bool _hasCheckedSubmissionStatus = false;

  final PageController _pageController = PageController();
  late Timer scrollTimer;
  int currentIndex = 0;
  final List<String> images = [
    'assets/1.jpeg',
    'assets/2.jpeg',
    'assets/3.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    // Fetch initial data
    fetchProfileImage();
    fetchNotificationCount();
    fetchAppointments();
    checkAndShowSubmissionStatus();
    startScrollTimer();
  }

  Future<void> fetchProfileImage() async {
    try {
      final response = await http.get(Uri.parse("${Config.baseUrl}/imagepatient.php?patientId=${widget.patientId}"));
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _profileImage = data['image'] ?? '';
        });
      } else {
        print('Failed to fetch profile image: ${data['error'] ?? "Unknown error"}');
      }
    } catch (error) {
      print('Error fetching profile image: $error');
    }
  }

  Future<void> fetchNotificationCount() async {
    try {
      final response = await http.get(Uri.parse("${Config.baseUrl}/get_notifications_patient.php?patientId=${widget.patientId}"));
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _notificationCount = data['notification_count'] ?? 0;
        });
      } else {
        print('Failed to fetch notification count: ${data['error'] ?? "Unknown error"}');
      }
    } catch (error) {
      print('Error fetching notification count: $error');
    }
  }

  Future<void> fetchAppointments() async {
    try {
      final response = await http.get(Uri.parse("${Config.baseUrl}/appointment1.php?status=pending&patientId=${widget.patientId}"));
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _pendingAppointments = data ?? [];
        });
        // Print the pending appointments to the console
        print('Pending Appointments: ${jsonEncode(_pendingAppointments)}');
      } else {
        print('Failed to fetch appointments: ${data['error'] ?? "Unknown error"}');
      }
    } catch (error) {
      print('Error fetching appointments: $error');
    }
  }


  Future<void> fetchSubmissionStatus() async {
    try {
      final response = await http.get(Uri.parse("${Config.baseUrl}/popmessage.php?patientId=${widget.patientId}"));
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Submission Status"),
            content: Text(data['message'] ?? "No message available."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
        );
      } else {
        print('Failed to fetch submission status: ${data['error'] ?? "Unknown error"}');
      }
    } catch (error) {
      print('Error fetching submission status: $error');
    }
  }

  Future<void> checkAndShowSubmissionStatus() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? lastShownDate = prefs.getString("lastShownDate_${widget.patientId}");
      String today = DateTime.now().toIso8601String().split('T')[0];

      if (lastShownDate != today && !_hasCheckedSubmissionStatus) {
        await fetchSubmissionStatus();
        await prefs.setString("lastShownDate_${widget.patientId}", today);
        _hasCheckedSubmissionStatus = true;
      }
    } catch (error) {
      print('Error checking or setting submission status: $error');
    }
  }

  void startScrollTimer() {
    scrollTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      // Update the currentIndex and animate to the next page
      setState(() {
        currentIndex = (currentIndex + 1) % images.length;
      });
      _pageController.animateToPage(
        currentIndex,
        duration: Duration(milliseconds: 500), // Smooth transition
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    scrollTimer.cancel();
    super.dispose();
  }

  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        images.length,
            (index) => GestureDetector(
          onTap: () => _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.easeInOut),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: currentIndex == index ? Colors.teal : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshAllContents() async {
    await fetchProfileImage();
    await fetchNotificationCount();
    await fetchAppointments();
    await checkAndShowSubmissionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2DC2D7),
        toolbarHeight: 80, // Increased AppBar height to 80
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/PatientProfileScreen', // Replace with your profile screen route
                  arguments: {'patientId': widget.patientId},
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 24, // Increased avatar size slightly for proportion
                  backgroundImage: _profileImage.isNotEmpty ? NetworkImage(_profileImage) : null,
                  child: _profileImage.isEmpty ? Icon(Icons.person, size: 24) : null,
                ),
              ),
            ),
            SizedBox(width: 12),
            Text(
              widget.name.length > 6 ? '${widget.name.substring(0, 6)}...' : widget.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Adjusted for larger AppBar
            ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                color: Colors.black87,
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/PatientNotificationScreen', // Replace with your notification screen route
                    arguments: {'patientId': widget.patientId},
                  );
                },
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_notificationCount',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                      maxLines: 1, // Limit text to one line
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      // The rest of your Scaffold body content goes here


  drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2DC2D7), Color(0xFF045D94)], // Gradient from teal to a darker shade
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to the profile screen and pass the patientId
                      Navigator.pushNamed(
                        context,
                        '/PatientProfileScreen', // Replace with your actual route name
                        arguments: {'patientId': widget.patientId},
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // shadow offset for 3D effect
                          ),
                        ],
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: CircleAvatar(
                        radius: 40, // Slightly larger radius for emphasis
                        backgroundImage: _profileImage.isNotEmpty
                            ? NetworkImage(_profileImage)
                            : null,
                        child: _profileImage.isEmpty
                            ? Icon(Icons.person, size: 40, color: Colors.white) // White icon if no image
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Space between avatar and text
                  Text(
                    widget.name.length > 10
                        ? '${widget.name.substring(0, 10)}...'
                        : widget.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12, // Larger font size for name
                      fontWeight: FontWeight.bold, // Bold for emphasis
                      letterSpacing: 1.2, // Slight letter spacing for elegance
                    ),
                  ),

                ],
              ),
            ),

            // Example of adding icons with text and passing patientId


            ListTile(
              leading: Icon(Icons.video_library),
              title: Text('Daily Activity'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/DailyActivityScreen',
                  arguments: {'patientId': widget.patientId},
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Pending of Appointments',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pushNamed(context, '/AllAppointmentsScreen', arguments: widget.patientId);

              },
            ),
            ListTile(
              leading: Icon(Icons.trending_up),
              title: Text('Daily Progress'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/DailyProgressScreen',
                  arguments: {'patientId': widget.patientId},
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Patient Notifications',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/PatientNotificationScreen',
                  arguments: {'patientId': widget.patientId},
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
               title: Text(
    'Questionnaires',
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/QuestionnairesScreen1',
                  arguments: {'patientId': widget.patientId},

                );
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.whatsapp),
              title: Text('WhatsApp Chat'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/patientwhatsapp',
                  arguments: {'patientId': widget.patientId},
                );
              },  // <- Make sure this comma and parenthesis exist
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Appointments'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/AddAppointmentScreen',
                  arguments: {'patientId': widget.patientId},
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.videocam),
              title: Text('View Videos'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/ViewVideosScreen',
                  arguments: {'patientId': widget.patientId},
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Patient Reports'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/PatientReportedScreen',
                  arguments: {'patientId': widget.patientId},
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('logout'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/LoginOptions',
                );
              },
            ),
          ],
        ),
      ),

      body: RefreshIndicator(
        onRefresh: _refreshAllContents,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              // Image carousel with dots overlay
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 200,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          images[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  // Dots inside the container
                  Positioned(
                    bottom: 10, // Adjust this for padding between image and dots
                    child: buildDots(),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10),
                 child: PendingAppointmentsWidget(
                pendingAppointments: _pendingAppointments,
                patientId: widget.patientId, // Pass the patientId
                onAppointmentTap: (doctorId, doctorImage, appointmentId) {

                },
              ),

        ),
            ],
          ),
        ),
      ),
    );
  }
}
