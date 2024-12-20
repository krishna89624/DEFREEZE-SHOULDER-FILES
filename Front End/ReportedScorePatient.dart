import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ReportedScorePatient extends StatefulWidget {
  @override
  _ReportedScorePatientState createState() => _ReportedScorePatientState();
}

class _ReportedScorePatientState extends State<ReportedScorePatient> {
  DateTime? selectedMonth;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String patientId = args['patientId'];
    final List<dynamic> scores = args['scores'];

    // Group scores by month
    Map<String, List<dynamic>> monthlyScores = {};
    for (var score in scores) {
      String date = score['created_at'];
      DateTime scoreDate = DateTime.parse(date);
      String monthYear = DateFormat('MMMM yyyy').format(scoreDate);
      if (!monthlyScores.containsKey(monthYear)) {
        monthlyScores[monthYear] = [];
      }
      monthlyScores[monthYear]!.add(score);
    }

    // Filter scores based on selected month
    List<dynamic> filteredScores = [];
    String selectedMonthYear = '';
    if (selectedMonth != null) {
      selectedMonthYear = DateFormat('MMMM yyyy').format(selectedMonth!);
      filteredScores = monthlyScores[selectedMonthYear] ?? [];
    }

    // Calculate average DASH score for the selected month
    double averageScore = 0;
    if (filteredScores.isNotEmpty) {
      averageScore = filteredScores.map((score) => score['dashScore']).reduce((a, b) => a + b) / filteredScores.length;
    }

    // Determine category, color, and message for the average score
    List<PieChartData> pieChartData = [];
    Color categoryColor = Colors.black;
    String message;

    if (filteredScores.isEmpty) {
      categoryColor = Colors.red;
      message = 'No data this month.';
    } else if (averageScore >= 0 && averageScore <= 40) {
      pieChartData = [PieChartData('Stable', 100.0, Colors.green)];
      categoryColor = Colors.green;
      message = 'Your condition seems stable.';
    } else if (averageScore > 40 && averageScore <= 70) {
      categoryColor = Colors.orange;
      pieChartData = [
        PieChartData('Worsening', averageScore, categoryColor),
        PieChartData('Remaining', 100 - averageScore, Colors.grey.shade300)
      ];
      message = 'Your condition seems to be worsening. Consider booking an appointment.';
    } else {
      categoryColor = Colors.red;
      pieChartData = [
        PieChartData('Severe', averageScore, categoryColor),
        PieChartData('Remaining', 100 - averageScore, Colors.grey.shade300)
      ];
      message = 'Your condition seems severe. Please book an appointment immediately.';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reported Scores for $patientId',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF2DC2D7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2DC2D7),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedMonth ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  helpText: 'Select Month',
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: Color(0xFF2DC2D7),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedMonth = DateTime(pickedDate.year, pickedDate.month);
                  });
                }
              },
              child: Text(selectedMonth == null
                  ? 'Select Month'
                  : 'Selected Month: ${DateFormat('MMMM yyyy').format(selectedMonth!)}'),
            ),
            if (selectedMonth != null) ...[
              SizedBox(height: 16),
              if (filteredScores.isEmpty)
                Text(
                  message,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: categoryColor),
                  textAlign: TextAlign.center,
                ),
              if (filteredScores.isNotEmpty) ...[
                SfCircularChart(
                  title: ChartTitle(
                    text: 'DASH Score for $selectedMonthYear',
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  legend: Legend(isVisible: true),
                  series: <CircularSeries>[
                    PieSeries<PieChartData, String>(
                      dataSource: pieChartData,
                      xValueMapper: (PieChartData data, _) => data.category,
                      yValueMapper: (PieChartData data, _) => data.value,
                      pointColorMapper: (PieChartData data, _) => data.color,
                      dataLabelMapper: (PieChartData data, _) => '${data.category}: ${data.value.toStringAsFixed(1)}%',
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    )
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: categoryColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredScores.length,
                    itemBuilder: (context, index) {
                      final score = filteredScores[index];
                      return Card(
                        color: Colors.white,
                        elevation: 4,
                        shadowColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          title: Text(
                            'DASH Score: ${score['dashScore']}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            'Date: ${score['created_at']}\nDifficulty: ${score['difficultyCategory']}',
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                          trailing: Text(
                            'Answered: ${score['numberOfAnsweredItems']}',
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ]
          ],
        ),
      ),
    );
  }
}

class PieChartData {
  final String category;
  final double value;
  final Color color;

  PieChartData(this.category, this.value, this.color);
}
