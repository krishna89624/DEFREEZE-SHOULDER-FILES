import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart'; // Import your config file for baseUrl

class WeeklyQuestionsScreen extends StatefulWidget {
  final String patientId;

  const WeeklyQuestionsScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  _WeeklyQuestionsScreenState createState() => _WeeklyQuestionsScreenState();
}

class _WeeklyQuestionsScreenState extends State<WeeklyQuestionsScreen> {
  List<String> dates = [];
  List<dynamic> data = [];
  String error = '';
  String? selectedDate;
  int currentPage = 1;
  final int itemsPerPage = 15;

  @override
  void initState() {
    super.initState();
    fetchDates();
  }

  Future<void> fetchDates() async {
    try {
      final response = await http.get(Uri.parse('${Config.patentdataUrl}?patientId=${widget.patientId.trim()}'));

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        // Check if responseData is a List
        if (responseData is List && responseData.isNotEmpty) {
          final uniqueDates = responseData
              .map((item) => item['created_at'].split(' ')[0])
              .toSet()
              .toList()
              .cast<String>();

          uniqueDates.sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));
          setState(() {
            dates = uniqueDates;
            error = '';
          });
        } else {
          setState(() {
            error = 'No data available ';
          });
        }
      } else {
        setState(() {
          error = 'Failed to fetch dates. Status code: ${response.statusCode}';
        });
      }
    } catch (err) {
      setState(() {
        error = 'Failed to fetch dates: $err';
      });
    }
  }

  Future<void> fetchDataForDate(String date) async {
    try {
      final response = await http.get(Uri.parse('${Config.patentdataUrl}?patientId=${widget.patientId.trim()}&date=$date'));

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        if (responseData is List) {
          setState(() {
            data = responseData;
            error = '';
          });
        } else {
          setState(() {
            error = 'Unexpected response format: expected a list';
          });
        }
      } else {
        setState(() {
          error = 'Failed to fetch data. Status code: ${response.statusCode}';
        });
      }
    } catch (err) {
      setState(() {
        error = 'Failed to fetch data: $err';
      });
    }
  }

  List<dynamic> getCurrentPageData() {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return data.sublist(startIndex, endIndex > data.length ? data.length : endIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Data'),
        backgroundColor: Color(0xFF2DC2D7),
        actions: [
          IconButton(
            icon: Icon(Icons.report),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/PatientReportedScreen',
                arguments: {
                  'patientId': widget.patientId,
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (error.isNotEmpty) Text(error, style: TextStyle(color: Colors.red)),
            if (selectedDate == null) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          dates[index],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          setState(() {
                            selectedDate = dates[index];
                          });
                          fetchDataForDate(dates[index]);
                        },
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF2DC2D7),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                ),
                onPressed: () {
                  setState(() {
                    selectedDate = null;
                    data.clear();
                  });
                },
                child: Text(
                  'Back to Date List',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: getCurrentPageData().length,
                  itemBuilder: (context, index) {
                    final item = getCurrentPageData()[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          '${index + 1 + (currentPage - 1) * itemsPerPage}: ${item['questions']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Option: ${item['options']}', style: TextStyle(color: Colors.grey[600])),
                            Text('Score: ${item['score']}', style: TextStyle(color: Colors.grey[600])),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2DC2D7),
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    onPressed: currentPage > 1 ? () => setState(() => currentPage--) : null,
                    child: Text('Previous'),
                  ),
                  Text('${currentPage} / ${((data.length / itemsPerPage).ceil())}'),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2DC2D7),
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    onPressed: (currentPage * itemsPerPage) < data.length ? () => setState(() => currentPage++) : null,
                    child: Text('Next'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
