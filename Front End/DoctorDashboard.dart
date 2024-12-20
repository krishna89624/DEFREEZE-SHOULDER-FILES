import 'dart:async';
import 'package:flutter/material.dart';
import 'config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'doctor_appointments.dart';
import 'CircleAvatarWithBorder.dart';


class DoctorDashboard extends StatefulWidget {
  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final PageController _pageController = PageController();
  final List<String> _images = ['assets/1.jpg', 'assets/2.jpg', 'assets/3.jpg'];
  int _currentIndex = 0, _notificationCount = 0;
  Timer? _timer;
  List<dynamic> _pendingAppointments = [];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotificationCount();
      _fetchAppointments('pending');
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() => _currentIndex = (_currentIndex + 1) % _images.length);
      _pageController.animateToPage(_currentIndex, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  Future<void> _fetchNotificationCount() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final response = await http.get(Uri.parse("${Config.getNotificationsUrl}?doctorId=${args['doctorId']}"));
    if (response.statusCode == 200) {
      setState(() => _notificationCount = json.decode(response.body)['notification_count'] ?? 0);
    }
  }

  Future<void> _fetchAppointments(String status) async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    // Make the HTTP GET request
    final response = await http.get(Uri.parse(Config.getAppointmentsUrl(args['doctorId'], status)));

    if (response.statusCode == 200) {
      // Decode the response body and update the state
      setState(() {
        _pendingAppointments = jsonDecode(response.body);
      });

      // Log the response body to the console
      print('Response Body: ${response.body}');
    } else {
      // Handle the case where the server response was not 200
      print('Failed to load appointments. Status code: ${response.statusCode}');
    }
  }


  Future<void> _refreshAllContents() async {
    await _fetchNotificationCount();
    await _fetchAppointments('pending');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  String formatDoctorName(String name) {
    return name.length <= 9 ? name : '${name.substring(0, 9)}...';
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      drawer: _buildDrawer(args),
      body: Column(
        children: [
          _buildTopBar(args),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshAllContents,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    _buildImageCarousel(),
                    SizedBox(height: 3),
                    DoctorAppointments(
                      pendingAppointments: _pendingAppointments,
                      doctorId: args['doctorId'],
                      doctorName: args['doctorName'],
                      doctorSpecialization: args['doctorSpecialization'],
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showActionMenu,
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF2DC2D7),
      ),
    );
  }

  void _showActionMenu() {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.person_add, color: Color(0xFF2DC2D7)),
                title: Text('Add Patient', style: TextStyle(color: Color(0xFF2DC2D7))),
                onTap: () {
                  Navigator.pop(context);
                  navigateToAddPatient();
                },
              ),
              ListTile(
                leading: Icon(Icons.video_library, color: Color(0xFF2DC2D7)),
                title: Text('Add Videos', style: TextStyle(color: Color(0xFF2DC2D7))),
                onTap: () {
                  Navigator.pop(context);
                  navigateToAddVideos();
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Color(0xFF2DC2D7)),
                title: Text('Logout', style: TextStyle(color: Color(0xFF2DC2D7))),
                onTap: () {
                  Navigator.pop(context);
                  navigateToLoginOptions();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Drawer _buildDrawer(Map<String, dynamic> args) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildProfileHeader(args),
          _buildDrawerItem(Icons.person, 'Doctor Profile', () {
            Navigator.pushNamed(context, '/doctorProfile', arguments: args);
          }),
          _buildDrawerItem(Icons.notifications, 'Notifications', () {
            Navigator.pushNamed(context, '/doctorNotifications', arguments: args);
          }),
          _buildDrawerItem(Icons.list, 'Appointments', () {
            Navigator.pushNamed(context, '/AppointmentsScreen', arguments: args);
          }),
          _buildDrawerItem(Icons.video_library, 'Add Videos', navigateToAddVideos),
          _buildDrawerItem(Icons.add, 'Add Patient', navigateToAddPatient),
          _buildDrawerItem(Icons.people, 'View All Patients', () {
            Navigator.pushNamed(context, '/AllPatientsScreen', arguments: {
              'doctorId': args['doctorId'],
              'doctorName': args['doctorName'],
              'doctorSpecialization': args['doctorSpecialization'],

            });
          }),
          _buildDrawerItem(Icons.logout, 'Logout', navigateToLoginOptions),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> args) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2DC2D7), Color(0xFF00A0C6)], // Gradient colors
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/doctorProfile', arguments: args),
            child: CircleAvatarWithBorder(
              imageUrl: args['doctorImage'],
              borderRadius: 40, // Set the outer circle avatar radius to 40
              avatarRadius: 35,  // Set the inner avatar radius to 35 for a total size of 80
            ),
          ),
          SizedBox(height: 12),
          Text(
            formatDoctorName('Dr. ${args['doctorName']}'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 5),
          Text(
            args['doctorSpecialization'],
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
            overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
            maxLines: 1, // Limit to one line
          ),
          // Removed the "Available" button section
        ],
      ),
    );
  }



  _buildTopBar(Map<String, dynamic> args) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 26),
      color: Color(0xFF2DC2D7),
      child: Row(
        children: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            },
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/doctorProfile', arguments: args),
            child: CircleAvatarWithBorder(
              imageUrl: args['doctorImage'],
              borderRadius: 20,  // Smaller border radius for top bar
              avatarRadius: 18,
              borderColor: Colors.grey[300]!,
            ),
          ),
          SizedBox(width: 12),
          Text(formatDoctorName('Dr. ${args['doctorName']}'), style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          Spacer(),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.white),
                onPressed: () => Navigator.pushNamed(context, '/doctorNotifications', arguments: args),
              ),
              if (_notificationCount > 0) _buildNotificationBadge(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBadge() {
    return Positioned(
      right: 20,
      top: 5,
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            '$_notificationCount',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,  // Fixed font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildImageCarousel() {
    return Stack(
      children: [
        Container(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            itemBuilder: (context, index) => Image.asset(_images[index], fit: BoxFit.cover),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_images.length, (index) => _buildIndicator(index)),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentIndex == index ? 16 : 8,
      decoration: BoxDecoration(
        color: _currentIndex == index ? Colors.black : Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  void navigateToAddPatient() {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    Navigator.pushNamed(context, '/AddPatient', arguments: {
      'doctorId': args['doctorId'],
      'doctorName': args['doctorName'],
      'doctorSpecialization': args['doctorSpecialization'],
    });
  }

  void navigateToAddVideos() {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    Navigator.pushNamed(context, '/AddVideos', arguments: {
      'doctorId': args['doctorId'],
      'doctorName': args['doctorName'],
      'doctorSpecialization': args['doctorSpecialization'],
    });
  }

  void navigateToLoginOptions() {
    Navigator.pushNamed(context, '/LoginOptions');
  }
}
