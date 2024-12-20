import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
class PieChartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    String patientId = args['patientId'];
    double dashScore = args['dashScore'];
    int numberOfAnsweredItems = args['numberOfAnsweredItems'];
    double sumOfScores = args['sumOfScores'];

    final difficultyInfo = getDifficultyCategory(dashScore);

    Map<String, double> dataMap = {
      "DASH Score": dashScore,
      "Remaining": 100 - dashScore,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient Overview',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF2DC2D7),
        elevation: 4.0,
        shadowColor: Colors.black54,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'Patient Details',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2DC2D7),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Divider(color: Color(0xFF2DC2D7), thickness: 1),
              SizedBox(height: 10),
              _buildInfoCard("Patient ID:", patientId),
              _buildInfoCard("DASH Score:", dashScore.toStringAsFixed(2)),
              _buildInfoCard("Answered Items:", numberOfAnsweredItems.toString()),
              _buildInfoCard("Sum of Scores:", sumOfScores.toStringAsFixed(2)),
              _buildInfoCard("Difficulty Category:", difficultyInfo['category'] ?? 'N/A'),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  difficultyInfo['description'] ?? 'No description available',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(int.parse(difficultyInfo['color'] ?? '0xFF9E9E9E')),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: PieChart(
                      dataMap: dataMap,
                      chartRadius: MediaQuery.of(context).size.width / 2.2,
                      colorList: [Color(0xFF2DC2D7), Colors.grey.shade400],
                      legendOptions: LegendOptions(
                        showLegends: true,
                        legendPosition: LegendPosition.bottom,
                        legendTextStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValuesInPercentage: true,
                        decimalPlaces: 1,
                        chartValueStyle: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Delay before popping the screen
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pop(context);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2DC2D7),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  ),
                  child: Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2DC2D7),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String> getDifficultyCategory(double score) {
    if (score >= 0 && score <= 20) {
      return {
        'category': 'Little to no difficulty',
        'description': 'The individual experiences minimal to no issues with daily activities.',
        'color': '0xFF4CAF50'
      };
    } else if (score > 20 && score <= 40) {
      return {
        'category': 'Mild difficulty',
        'description': 'The individual has some difficulty but can still perform most activities with mild limitations.',
        'color': '0xFFFFC107'
      };
    } else if (score > 40 && score <= 60) {
      return {
        'category': 'Moderate difficulty',
        'description': 'The individual faces moderate challenges and may need to adapt how they perform certain tasks.',
        'color': '0xFFFF9800'
      };
    } else if (score > 60 && score <= 80) {
      return {
        'category': 'Severe difficulty',
        'description': 'The individual has significant difficulty performing many activities and may need substantial assistance.',
        'color': '0xFFF44336'
      };
    } else if (score > 80 && score <= 100) {
      return {
        'category': 'Extreme difficulty',
        'description': 'The individual is unable to perform most activities and experiences severe limitations.',
        'color': '0xFF9C27B0'
      };
    } else {
      return {
        'category': 'Invalid score',
        'description': 'The provided score is not within a valid range.',
        'color': '0xFF9E9E9E'
      };
    }
  }
}
