import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class MedicalHistoryScreen extends StatefulWidget {
  final String patientId;

  const MedicalHistoryScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  _MedicalHistoryScreenState createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  bool loading = true;
  int currentPage = 1;
  String topBarText = '';
  List submittedData = [];

  @override
  void initState() {
    super.initState();
    setTopBarTextAndQuestions(currentPage);
    fetchSubmittedData(widget.patientId);
  }

  void setTopBarTextAndQuestions(int screenNumber) {
    switch (screenNumber) {
      case 1:
        setState(() {
          topBarText = 'Medical History';
        });
        break;
      case 2:
        setState(() {
          topBarText = 'Frozen Shoulder Symptoms';
        });
        break;
      case 3:
        setState(() {
          topBarText = 'Lifestyle and Activities';
        });
        break;
      case 4:
        setState(() {
          topBarText = 'Treatment and Management';
        });
        break;
      default:
        setState(() {
          topBarText = '';
        });
        break;
    }
  }

  Future<void> fetchSubmittedData(String patientId) async {
    try {
      setState(() {
        loading = true;
      });
      final response = await http.get(Uri.parse('${Config.baseUrl}/doctor_Ans.php?patientId=$patientId'));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch submitted data');
      }

      final data = json.decode(response.body);
      setState(() {
        submittedData = data;
        loading = false;
      });
    } catch (error) {
      setState(() {
        loading = false;
      });
      // Handle error (e.g., show a dialog)
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error', style: TextStyle(color: Colors.red)),
            content: Text('Failed to fetch submitted data. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void handleNextPage() {
    if (currentPage < 4) {
      setState(() {
        currentPage++;
        setTopBarTextAndQuestions(currentPage);
      });
    }
  }

  void handlePrevPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        setTopBarTextAndQuestions(currentPage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final submittedDataToShow = submittedData.skip((currentPage - 1) * 4).take(4).toList();

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.bottomLeft, // Forces the title to stay exactly at the center
          child: Text(
            topBarText,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color(0xFF2DC2D7),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: loading
            ? Center(child: CircularProgressIndicator())
            : submittedDataToShow.isEmpty
            ? Center(child: Text('No data available.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text('Submitted At: ${submittedDataToShow[0]['created_at']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Expanded(
              child: ListView.builder(
                itemCount: submittedDataToShow.length,
                itemBuilder: (context, index) {
                  final item = submittedDataToShow[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Question: ${item['questions']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Answer: ${item['options']}', style: TextStyle(fontSize: 16)),
                          if (item['inp_data'] != null && item['inp_data'].isNotEmpty)
                            Text('Additional Info: ${item['inp_data']}', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentPage > 1)
                  ElevatedButton(
                    onPressed: handlePrevPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2DC2D7),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Previous', style: TextStyle(fontSize: 16)),
                  ),
                if (currentPage < 4)
                  ElevatedButton(
                    onPressed: handleNextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2DC2D7),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Next', style: TextStyle(fontSize: 16)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
