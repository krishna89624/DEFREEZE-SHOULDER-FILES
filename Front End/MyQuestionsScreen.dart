import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class MyQuestionsScreen extends StatefulWidget {
  final String patientId;
  final String name;
  final String patientCase;
  final String contactNo;

  const MyQuestionsScreen({
    Key? key,
    required this.patientId,
    required this.name,
    required this.patientCase,
    required this.contactNo,
  }) : super(key: key);

  @override
  _MyQuestionsScreenState createState() => _MyQuestionsScreenState();
}

class _MyQuestionsScreenState extends State<MyQuestionsScreen> {
  bool loading = false;
  List<Map<String, dynamic>> allQuestions = [];
  Map<int, bool> showInputField = {};
  Map<int, TextEditingController> textControllers = {};
  Map<int, String?> selectedOptions = {};
  int currentSection = 0; // Index of the current section (0-based index)

  // Define question ranges and section names
  final List<Map<String, dynamic>> questionRanges = [
    {'name': 'Medical History', 'range': [0, 4]},  // Questions 1 to 4
    {'name': 'Frozen Shoulder Symptoms', 'range': [4, 9]},  // Questions 5 to 9
    {'name': 'Lifestyle and Activities', 'range': [9, 13]}, // Questions 10 to 13
    {'name': 'Treatment and Management', 'range': [13, 17]}, // Questions 14 to 17
  ];

  Future<void> fetchQuestions() async {
    try {
      setState(() {
        loading = true;
      });

      final response = await http.get(Uri.parse(Config.getQuestionsUrl));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch questions');
      }

      final List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> fetchedQuestions = data
          .map((question) => Map<String, dynamic>.from(question as Map))
          .toList();

      setState(() {
        allQuestions = fetchedQuestions;
        loading = false;
      });
    } catch (error) {
      print('Error fetching questions: $error');
      setState(() {
        loading = false;
      });
      _showAlert('Error', 'Failed to fetch questions. Please try again later.');
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void submitAnswers() async {
    List<String> questions = [];
    List<Map<String, String>> answers = [];
    bool allQuestionsAnswered = true;
    bool inputFieldsCompleted = true; // Check if input fields are filled

    for (int index = 0; index < allQuestions.length; index++) {
      final question = allQuestions[index];
      final questionId = int.parse(question['id']);
      questions.add(question['questions']);

      String selectedOption = selectedOptions[questionId] ?? '';
      String inputData = textControllers[questionId]?.text ?? '';

      // Check if any question is unanswered
      if (selectedOption.isEmpty) {
        allQuestionsAnswered = false;
      }

      // Check if input is required and filled when 'Yes' is selected
      if (selectedOption == 'Yes' && inputData.isEmpty) {
        inputFieldsCompleted = false;
      }

      answers.add({
        'option': selectedOption,
        'inp_data': inputData,
      });
    }

    if (!allQuestionsAnswered) {
      _showAlert('Warning', 'Please answer all questions before submitting.');
      return; // Prevent submission if questions are not fully answered
    }

    if (!inputFieldsCompleted) {
      _showAlert('Warning', 'Please fill in all input fields for questions answered "Yes" before submitting.');
      return; // Prevent submission if input fields are not filled
    }

    final Map<String, dynamic> dataToSend = {
      'patientId': widget.patientId,
      'questions': questions,
      'answers': answers,
    };

    try {
      final response = await http.post(
        Uri.parse(Config.submitAnswersUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(dataToSend),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Display success message
        _showAlert('Success', responseData['message']);

        // Navigate to Patient Dashboard with all patient details
        Navigator.pushNamed(context, '/PatientDashboardScreen', arguments: {
          'patientId': widget.patientId,
          'name': widget.name,
          'patientCase': widget.patientCase,
          'contactNo': widget.contactNo,
        });
      } else {
        _showAlert('Error', 'Failed to submit answers. Please try again.');
      }
    } catch (error) {
      _showAlert('Error', 'An error occurred while submitting answers.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(questionRanges[currentSection]['name']), // Dynamically set section name
        backgroundColor: Color(0xFF2DC2D7), // Set the AppBar color
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: submitAnswers,
          ),
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Expanded(
            child: allQuestions.isEmpty
                ? Center(child: Text('No questions available'))
                : ListView.builder(
              itemCount: questionRanges[currentSection]['range'][1] - questionRanges[currentSection]['range'][0],
              itemBuilder: (context, index) {
                final questionIndex = questionRanges[currentSection]['range'][0] + index;
                final question = allQuestions[questionIndex];
                final questionId = int.parse(question['id']);

                Color yesButtonColor = selectedOptions[questionId] == 'Yes' ? Colors.green : Colors.blue;
                Color noButtonColor = selectedOptions[questionId] == 'No' ? Colors.red : Colors.blue;

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${question['id']}: ${question['questions']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedOptions[questionId] = 'Yes';
                                  showInputField[questionId] = true;
                                  textControllers[questionId] ??= TextEditingController();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: yesButtonColor, // Use backgroundColor instead of primary
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Yes'),
                            ),
                            SizedBox(width: 8.0),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedOptions[questionId] = 'No';
                                  showInputField[questionId] = false;
                                  textControllers[questionId]?.clear();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: noButtonColor, // Use backgroundColor instead of primary
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('No'),
                            ),
                          ],
                        ),
                        if (showInputField[questionId] == true) ...[
                          SizedBox(height: 8.0),
                          TextField(
                            controller: textControllers[questionId],
                            decoration: InputDecoration(
                              labelText: 'Please provide details',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Navigation buttons for sections
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentSection > 0
                      ? () {
                    setState(() {
                      currentSection--;
                    });
                  }
                      : null,
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: currentSection < questionRanges.length - 1
                      ? () {
                    setState(() {
                      currentSection++;
                    });
                  }
                      : null,
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of text controllers
    for (var controller in textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
