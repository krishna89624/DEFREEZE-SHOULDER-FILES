import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PendingAppointmentsWidget extends StatefulWidget {
  final List<dynamic> pendingAppointments;
  final String patientId;
  final Function(String doctorId, String doctorImage, String appointmentId) onAppointmentTap;

  PendingAppointmentsWidget({
    required this.pendingAppointments,
    required this.patientId,
    required this.onAppointmentTap,
  });

  @override
  _PendingAppointmentsWidgetState createState() => _PendingAppointmentsWidgetState();
}

class _PendingAppointmentsWidgetState extends State<PendingAppointmentsWidget> {
  final icons = [
    IconItem('Daily Activity', Icons.run_circle_outlined, '/DailyActivityScreen'),
    IconItem('Daily Progress', Icons.calendar_today, '/DailyProgressScreen'),
    IconItem('Weekly Questions', Icons.question_answer, '/QuestionnairesScreen1'),
    IconItem('Compare Weekly Scores', Icons.bar_chart, '/PatientReportedScreen'),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontScale = screenWidth / 375; // 375 is a common baseline width for scaling

    return Stack(
      children: [
        Column(
          children: [
            _buildPendingAppointmentsContainer(screenHeight, fontScale),
            SizedBox(height: 20 * fontScale),
            _buildQuickAccessContainer(screenHeight, screenWidth, fontScale),
          ],
        ),
        Positioned(
          bottom: 20 * fontScale,
          right: 20 * fontScale,
          child: FloatingActionButton(
            onPressed: _showActionMenu,
            backgroundColor: Color(0xFF2DC2D7),
            child: Icon(Icons.add, size: 24 * fontScale),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingAppointmentsContainer(double screenHeight, double fontScale) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(18.0 * fontScale),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12 * fontScale),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2 * fontScale,
                blurRadius: 5 * fontScale,
                offset: Offset(0, 3 * fontScale),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recently Pending Appointments',
                style: TextStyle(fontSize: 18 * fontScale, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                maxLines: 1, // Limit text to one line
              ),
              SizedBox(height: 16 * fontScale),
              Container(
                height: screenHeight * 0.26,
                child: widget.pendingAppointments.isNotEmpty
                    ? SingleChildScrollView(
                  child: Column(
                    children: widget.pendingAppointments.reversed.take(5).map((appointment) {
                      return GestureDetector(
                        onTap: () {
                          widget.onAppointmentTap(
                            appointment['doctorId'],
                            appointment['doctorImage'],
                            appointment['appointmentId'],
                          );
                          Navigator.pushNamed(
                            context,
                            '/AppointmentDetailsScreen',
                            arguments: {
                              'appointmentDetails': appointment,
                              'patientId': widget.patientId,
                            },
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 10 * fontScale),
                          padding: EdgeInsets.all(8 * fontScale),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8 * fontScale),
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF2DC2D7), width: 2 * fontScale),
                                  borderRadius: BorderRadius.circular(8 * fontScale),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8 * fontScale),
                                  child: Image.network(
                                    appointment['doctorImage'] ?? '',
                                    fit: BoxFit.cover,
                                    height: 60 * fontScale,
                                    width: 60 * fontScale,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.person, size: 50 * fontScale);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 12 * fontScale),
                              Expanded(
                                child: Text(
                                  'Appt ID: ${appointment['appointmentId'] ?? 'N/A'}',
                                  style: TextStyle(fontSize: 14 * fontScale),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
                    : Center(
                  child: Text(
                    'No pending appointments',
                    style: TextStyle(fontSize: 16 * fontScale, fontStyle: FontStyle.italic),
                    overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                    maxLines: 1, // Limit text to one line
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 220 * fontScale,
          right: 14 * fontScale,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/AllAppointmentsScreen', arguments: widget.patientId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2DC2D7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8 * fontScale),
              ),
            ),
            child: Text(
              'View All',
              style: TextStyle(fontSize: 12 * fontScale),
              overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
              maxLines: 1, // Limit text to one line
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessContainer(double screenHeight, double screenWidth, double fontScale) {
    return Container(
      height: screenHeight * 0.38,
      width: screenWidth * 0.95,
      padding: EdgeInsets.all(12.0 * fontScale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12 * fontScale),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2 * fontScale,
            blurRadius: 5 * fontScale,
            offset: Offset(0, 3 * fontScale),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Access',
            style: TextStyle(fontSize: 18 * fontScale, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
            maxLines: 1, // Limit text to one line
          ),
          SizedBox(height: 12 * fontScale),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20 * fontScale,
                mainAxisSpacing: 20 * fontScale,
                childAspectRatio: 1.52,
              ),
              itemCount: icons.length,
              itemBuilder: (context, index) {
                final iconItem = icons[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, iconItem.routeName, arguments: {'patientId': widget.patientId});
                  },
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(8 * fontScale),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: screenHeight * 0.08,  // Reduced icon size
                          width: screenHeight * 0.14,   // Reduced icon size
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8 * fontScale),
                            color: Colors.white.withOpacity(0.1),
                          ),
                          child: Icon(iconItem.icon, size: 50 * fontScale, color: Color(0xFF2DC2D7)),  // Reduced icon size
                        ),
                        SizedBox(height: 4 * fontScale), // Reduced gap
                        Flexible(
                          child: Text(
                            iconItem.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10 * fontScale, // Adjust font size
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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

  void _showActionMenu() {
    double fontScale = MediaQuery.of(context).size.width / 375;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16 * fontScale),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(FontAwesomeIcons.whatsapp, color: Color(0xFF2DC2D7), size: 24 * fontScale),
                title: Text('WhatsApp', style: TextStyle(fontSize: 16 * fontScale)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/patientwhatsapp', arguments: {'patientId': widget.patientId});
                },
              ),
              ListTile(
                leading: Icon(Icons.event, color: Color(0xFF2DC2D7), size: 24 * fontScale),
                title: Text('Doctor Appointment', style: TextStyle(fontSize: 16 * fontScale) ,overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
        maxLines: 1),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/AddAppointmentScreen', arguments: {'patientId': widget.patientId});
                },
              ),
              ListTile(
                leading: Icon(Icons.video_library, color: Color(0xFF2DC2D7), size: 24 * fontScale),
                title: Text('View Videos', style: TextStyle(fontSize: 16 * fontScale)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/ViewVideosScreen', arguments: {'patientId': widget.patientId});
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class IconItem {
  final String label;
  final IconData icon;
  final String routeName;

  IconItem(this.label, this.icon, this.routeName);
}
