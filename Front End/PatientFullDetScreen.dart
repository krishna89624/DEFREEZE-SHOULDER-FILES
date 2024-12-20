import 'package:flutter/material.dart';
import 'dart:convert'; // For decoding JSON
import 'package:http/http.dart' as http; // For making HTTP requests
import 'config.dart'; // Assuming you have a Config class that provides the URLs
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PatientFullDetScreen extends StatefulWidget {
  @override
  _PatientFullDetScreenState createState() => _PatientFullDetScreenState();
}

class _PatientFullDetScreenState extends State<PatientFullDetScreen> {
  Map<String, dynamic>? patientDetails;
  bool loading = true;
  String? errorMessage;
  String? patientId;
  String? patientImage;
  String? doctorId;
  String? doctorName;
  String? doctorSpecialization;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve arguments safely
    final routeArgs = ModalRoute
        .of(context)
        ?.settings
        .arguments;

    // Check if arguments are not null and are of the expected type
    if (routeArgs != null && routeArgs is Map<String, dynamic>) {
      final Map<String, dynamic> args = routeArgs;
      patientId = args['patientId'];
      patientImage = args['patientImage'];
      doctorId = args['doctorId'];
      doctorName = args['doctorName'];
      doctorSpecialization = args['doctorSpecialization'];
    } else {
      print('Warning: Invalid or missing route arguments.');
      _setError('Invalid or missing arguments!');
      return;
    }

    // Check if patientId is present
    if (patientId == null || patientId!.isEmpty) {
      _setError('Patient ID is missing!');
      return;
    }

    // Fetch patient details if not already loaded
    if (patientDetails == null) {
      fetchPatientDetails(patientId!);
    }
  }


  void _setError(String message) {
    setState(() {
      errorMessage = message;
      loading = false;
    });
  }

  Future<void> fetchPatientDetails(String patientId) async {
    final url = Uri.parse(Config.getPatientProfileUrl(patientId));
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          patientDetails = data;
          loading = false;
        });
      } else {
        _handleError(response);
      }
    } catch (error) {
      _setError('Failed to load patient details. Please try again later.');
    }
  }

  void _handleError(http.Response response) {
    String message;
    switch (response.statusCode) {
      case 404:
        message = 'Patient not found!';
        break;
      case 500:
        message = 'Server error. Please try again later.';
        break;
      default:
        message =
        'Failed to load patient details. Please check your internet connection.';
    }
    _setError(message);
  }

  String formatName(String name) {
    return name.length > 10 ? name.substring(0, 10) + '...' : name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
        backgroundColor: const Color(0xFF2DC2D7),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _buildPatientDetails(context),
      ),
    );
  }

  Widget _buildPatientDetails(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 16),
            _buildDetailInfo(),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(52),
            border: Border.all(color: Color(0xFF2DC2D7), width: 2),
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundImage: patientImage != null && patientImage!.isNotEmpty
                ? NetworkImage(patientImage!)
                : null,
            child: patientImage == null || patientImage!.isEmpty
                ? const Icon(Icons.person, size: 50)
                : null,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient ID: ${patientDetails?['id'] ?? patientId}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Name: ${formatName(patientDetails?['name'] ?? 'N/A')}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoBox('Age', patientDetails?['age'] ?? 'N/A'),
        _buildInfoBox('Gender', patientDetails?['gender'] ?? 'N/A'),
        _buildInfoBox('Contact Number', patientDetails?['contactNo'] ?? 'N/A'),
        _buildInfoBox('Height', patientDetails?['height'] ?? 'N/A'),
        _buildInfoBox('Weight', patientDetails?['weight'] ?? 'N/A'),
        _buildInfoBox('Patient Case', patientDetails?['patientCase'] ?? 'N/A'),
        _buildInfoBox(
            'Pain Duration', patientDetails?['painDuration'] ?? 'N/A'),
        _buildInfoBox('Admitted On', patientDetails?['admittedOn'] ?? 'N/A'),
        _buildInfoBox('RBS', patientDetails?['rbs'] ?? 'N/A'),
      ],
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    double buttonWidth = MediaQuery
        .of(context)
        .size
        .width * 0.35;

    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.video_call,
                label: 'Add Videos',
                route: '/AddVideoScreen1',
                width: buttonWidth,
              ),
              _buildActionButton(
                icon: Icons.show_chart,
                label: 'Daily Progress',
                route: '/DailyProgressScreen',
                width: buttonWidth,
              ),
            ],
          ),
          const SizedBox(height: 14), // Added SizedBox for consistent spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.help_outline,
                label: 'Questionnaires',
                route: '/QuestionnairesScreen',
                width: buttonWidth,
              ),
              _buildActionButton(
                icon: FontAwesomeIcons.whatsapp,
                label: 'WhatsApp',
                route: '/WhatsAppScreen',
                width: buttonWidth,
              ),
            ],
          ),
          const SizedBox(height: 16), // Added SizedBox for consistent spacing
          _buildActionButton(
            icon: Icons.calendar_today,
            label: 'Appointment',
            route: '/AppointmentScreen',
            width: buttonWidth * 2,
          ),
        ],
      ),
    );
  }

  ElevatedButton _buildActionButton({
    required IconData icon,
    required String label,
    required String route,
    required double width,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, 60),
        backgroundColor: Color(0xFF2DC2D7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5, // Set elevation to 5
      ),
      onPressed: () {
        // Passing arguments when navigating to the route
        Navigator.pushNamed(
          context,
          route,
          arguments: {
            'doctorId': doctorId,
            'patientId': patientId,
            'doctorName': doctorName,
            'contactNo': patientDetails?['contactNo'],
            'name': patientDetails?['name'],
            'doctorSpecialization': doctorSpecialization,
            'patientImage': patientImage,
            'patientDetails': patientDetails,
          },
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: Colors.white),
          const SizedBox(height: 3.5),
          Text(
            label,
            style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}