import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';
import 'config.dart';

class DailyProgressScreen extends StatefulWidget {
  final String patientId;

  DailyProgressScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  _DailyProgressScreenState createState() => _DailyProgressScreenState();
}

class _DailyProgressScreenState extends State<DailyProgressScreen> {
  List<dynamic>? report;
  DateTime? selectedDate;
  bool noRecords = false;
  bool loading = false;
  CalendarFormat _calendarFormat = CalendarFormat.month; // Default format

  Future<void> fetchDailyReport(String selectedDate) async {
    if (selectedDate.isEmpty) {
      _showErrorDialog('Please select a date first.');
      return;
    }

    setState(() {
      loading = true; // Start loading indicator
    });

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/fetch_daily_report.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'patientId': widget.patientId,
          'date': selectedDate,
        },
      );

      final data = json.decode(response.body);

      setState(() {
        loading = false; // Stop loading indicator
        if (data['success']) {
          if (data['report'].isEmpty) {
            noRecords = true;
            report = null;
          } else {
            report = data['report'];
            noRecords = false;
          }
        } else {
          _showErrorDialog(data['message']);
          noRecords = false;
        }
      });
    } catch (error) {
      print('Error fetching daily report: $error');
      _showErrorDialog('Failed to fetch daily report. Please try again later.');
      setState(() {
        loading = false;
        noRecords = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Getting screen height, width, and font scale factor
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double fontScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Progress'),
        backgroundColor: Color(0xFF2DC2D7),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0 * fontScale), // Adjusting padding
        child: Column(
          children: [
            TableCalendar(
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  selectedDate = selectedDay; // Update selected date
                });
                fetchDailyReport(selectedDay.toIso8601String().split('T')[0]); // Fetch report
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format; // Update the calendar format
                });
              },
              selectedDayPredicate: (day) => isSameDay(selectedDate, day),
              focusedDay: selectedDate ?? DateTime.now(),
              firstDay: DateTime.now().subtract(Duration(days: 365)),
              lastDay: DateTime.now().add(Duration(days: 365)),
              calendarFormat: _calendarFormat, // Set the calendar format
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF2DC2D7),
                  borderRadius: BorderRadius.circular(10.0 * fontScale), // Adjust border radius
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10.0 * fontScale),
                ),
                defaultDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0 * fontScale),
                ),
              ),
            ),
            SizedBox(height: 20 * fontScale), // Adjust gap
            if (loading)
              Center(child: CircularProgressIndicator(color: Color(0xFF2DC2D7)))
            else if (noRecords)
              Center(
                child: Text(
                  'No records found for the selected date.',
                  style: TextStyle(fontSize: 18 * fontScale, color: Colors.red),
                ),
              )
            else if (report != null)
                Expanded(
                  child: ListView.builder(
                    itemCount: report!.length,
                    itemBuilder: (ctx, index) {
                      final item = report![index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15 * fontScale), // Adjust border radius
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8 * fontScale),
                        child: Padding(
                          padding: EdgeInsets.all(16.0 * fontScale), // Adjust padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '1. Range of movement:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16 * fontScale),
                              ),
                              SizedBox(height: 8 * fontScale),
                              Text('Flexion & Extension: ${item['flexion']}° / ${item['extension']}°'),
                              SizedBox(height: 8 * fontScale),
                              Image.asset('assets/IMG_8264 3.png', width: 150 * fontScale, height: 150 * fontScale),
                              SizedBox(height: 8 * fontScale),
                              Text('Adduction & Abduction: ${item['adduction']}° / ${item['abduction']}°'),
                              SizedBox(height: 8 * fontScale),
                              Image.asset('assets/IMG_8264 1.png', width: 150 * fontScale, height: 150 * fontScale),
                              SizedBox(height: 8 * fontScale),
                              Text('2. Pain Scale: ${item['pain_scale']}'),
                              SizedBox(height: 8 * fontScale),
                              Text('3. Doing Exercises: ${item['doing_exercises']}'),
                              SizedBox(height: 8 * fontScale),
                              Text('Date: ${item['date']}'),
                              Text('Time: ${item['time']}'),
                            ],
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
