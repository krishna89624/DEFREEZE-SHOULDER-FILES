import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'config.dart';

class PatientReportedScreen extends StatefulWidget {
  @override
  _PatientReportedScreenState createState() => _PatientReportedScreenState();
}

class _PatientReportedScreenState extends State<PatientReportedScreen> {
  late String patientId;
  bool loading = true;
  List<dynamic> scores = [];
  List<double> lastTwoScores = [];
  String message = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    patientId = args['patientId'];
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('${Config.baseUrl}/reportedscore.php?patientId=$patientId'));

      // Print the response body to the console
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success']) {
          if (result['scores'].isNotEmpty) {
            scores = result['scores'];
            setState(() {
              updateLastTwoScores(scores);
            });
          } else {
            setState(() {
              message = 'No data available.';
            });
          }
        } else {
          setState(() {
            message = 'No data available.';
          });
        }
      } else {
        setState(() {
          message = 'Failed to fetch data.';
        });
      }
    } catch (error) {
      setState(() {
        message = 'Failed to fetch data: ${error.toString()}';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void updateLastTwoScores(List<dynamic> scores) {
    if (scores.isNotEmpty) {
      int length = scores.length;
      lastTwoScores = scores.sublist(length - 2 < 0 ? 0 : length - 2)
          .map((score) {
        final dashScore = score['dashScore'];
        return dashScore is num ? dashScore.toDouble() : 0.0;
      }).toList();

      double averageScore = lastTwoScores.isNotEmpty
          ? lastTwoScores.reduce((a, b) => a + b) / lastTwoScores.length
          : 0;

      if (averageScore >= 0 && averageScore <= 40) {
        message = 'Your condition seems stable.';
      } else if (averageScore > 40 && averageScore <= 70) {
        message = 'Your condition seems to be worsening. Consider booking an appointment.';
      } else {
        message = 'Your condition seems severe. Please book an appointment immediately.';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Dash Score'),
          backgroundColor: Color(0xFF2DC2D7),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    List<ChartData> chartData = [];
    if (scores.isNotEmpty) {
      int length = scores.length;
      chartData = scores.sublist(length - 2 < 0 ? 0 : length - 2)
          .map((score) {
        final dashScore = score['dashScore'];
        final createdAt = score['created_at'];

        String formattedDate = DateFormat('MMM dd').format(DateTime.parse(createdAt));

        return ChartData(formattedDate, dashScore is num ? dashScore.toDouble() : 0.0);
      }).toList();
    }

    // Reverse the chartData to display in reverse order
    chartData = chartData.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Dash Score'),
        backgroundColor: Color(0xFF2DC2D7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/ReportedScorePatient',
                  arguments: {
                    'patientId': patientId,
                    'scores': scores, // Pass the entire scores list
                  },
                );
              },
              child: Text('Pie Diagrams', style: TextStyle(color: Color(0xFF2DC2D7))),
            ),

            SizedBox(height: 20),
            Text(
              'DASH Score Bar Chart',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 10),
            Expanded(
              child: lastTwoScores.isNotEmpty
                  ? SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelRotation: -45,
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<ChartData, String>>[
                  ColumnSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.date,
                    yValueMapper: (ChartData data, _) => data.score,
                    color: Color(0xFF2DC2D7),
                    name: 'DASH Score',
                    borderColor: Colors.white,
                    borderWidth: 1.5,
                  ),
                ],
                primaryYAxis: NumericAxis(
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 14),
                  title: AxisTitle(text: 'Score', textStyle: TextStyle(fontSize: 16)),
                ),
              )
                  : Center(child: Text('No data available.', style: TextStyle(color: Colors.red))),
            ),
            SizedBox(height: 20),
            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2DC2D7), // Updated here
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String date;
  final double score;

  ChartData(this.date, this.score);
}
