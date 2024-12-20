import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'config.dart'; // Import your config file for baseUrl

class QuestionnairesScreen1 extends StatefulWidget {
  final String patientId;
  const QuestionnairesScreen1({Key? key, required this.patientId}) : super(key: key);

  @override
  _QuestionnairesScreen1State createState() => _QuestionnairesScreen1State();
}

class _QuestionnairesScreen1State extends State<QuestionnairesScreen1> {
  final Dio _dio = Dio();
  List<dynamic> questions = [];
  Map<String, dynamic> answers = {};
  String submissionStatus = '';
  bool loading = true;
  int currentPage = 0;
  final int questionsPerPage = 6;
  String waitMessage = '';

  final optionsMap = {
    1: ['No difficulty', 'Mild difficulty', 'Moderate difficulty', 'Severe difficulty', 'Unable'],
    22: ['Not at all', 'Slightly', 'Moderately', 'Quite a bit', 'Extremely'],
    23: ['Not limited at all', 'Slightly limited', 'Moderately limited', 'Very limited', 'Unable'],
    24: ['None', 'Mild', 'Moderate', 'Severe', 'Extreme'],
    25: ['None', 'Mild', 'Moderate', 'Severe', 'Extreme'],
    26: ['None', 'Mild', 'Moderate', 'Severe', 'Extreme'],
    27: ['None', 'Mild', 'Moderate', 'Severe', 'Extreme'],
    28: ['None', 'Mild', 'Moderate', 'Severe', 'Extreme'],
    29: ['No difficulty', 'Mild difficulty', 'Moderate difficulty', 'Severe difficulty', "So much I can't sleep"],
    30: ['Strongly disagree', 'Disagree', 'Neither agree nor disagree', 'Agree', 'Strongly agree']
  };

  @override
  void initState() {
    super.initState();
    checkSubmissionStatus();
  }

  Future<void> checkSubmissionStatus() async {
    try {
      final response = await _dio.get('${Config.patientPieChart}?patientId=${widget.patientId}');
      print('Submission Status Response: ${response.data}');

      setState(() {
        submissionStatus = response.data['submitted'] ? 'submitted' : 'not_submitted';
        waitMessage = response.data['waitingTime'] ?? '';
        loading = false;
      });

      if (submissionStatus == 'not_submitted') {
        fetchQuestions();
      }
    } catch (error) {
      print('Error checking submission status: $error');
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> fetchQuestions() async {
    try {
      final response = await _dio.get(Config.weeklyQuestions);
      if (response.statusCode == 200) {
        setState(() {
          questions = response.data;
          loading = false;
        });
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (error) {
      print('Error fetching questions: $error');
      setState(() {
        loading = false;
      });
      showErrorSnackbar('Failed to load questions. Please try again later.');
    }
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
    ));
  }

  void handleOptionChange(String questionText, String option) {
    setState(() {
      answers[questionText] = {
        'option': option,
        'score': getScoreForOption(option),
        'question': questionText
      };
    });
  }

  int getScoreForOption(String option) {
    const optionsToScore = {
      'No difficulty': 1,
      'Mild difficulty': 2,
      'Moderate difficulty': 3,
      'Severe difficulty': 4,
      'Unable': 5,
      'Not at all': 1,
      'Slightly': 2,
      'Moderately': 3,
      'Quite a bit': 4,
      'Extremely': 5,
      'Not limited at all': 1,
      'Slightly limited': 2,
      'Moderately limited': 3,
      'Very limited': 4,
      'None': 1,
      'Mild': 2,
      'Moderate': 3,
      'Severe': 4,
      'Extreme': 5,
      "So much I can't sleep": 5,
      'Strongly disagree': 1,
      'Disagree': 2,
      'Neither agree nor disagree': 3,
      'Agree': 4,
      'Strongly agree': 5,
    };
    return optionsToScore[option] ?? 0;
  }

  Future<void> handleSubmit() async {
    if (submissionStatus == 'submitted') {
      showErrorSnackbar('Your answers have already been submitted.');
      return; // Prevent further submission
    }

    List<String> unansweredQuestions = questions
        .where((question) => !answers.containsKey(question['question']))
        .map((q) => q['question'] as String)
        .toList();

    if (unansweredQuestions.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please answer all questions before submitting.'),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    List<Map<String, dynamic>> answersArray = answers.values.map((value) => {
      'question': value['question'],
      'option': value['option'],
      'score': value['score'],
    }).toList();

    double sumOfScores = answersArray.fold(0, (sum, item) => sum + (item['score'] as int));
    double averageScore = sumOfScores / answersArray.length;
    double dashScore = ((averageScore - 1) * 25);
    String difficultyCategory = getDifficultyCategory(dashScore);

    try {
      print('Submitting Answers: $answersArray');

      final answersResponse = await _dio.post('${Config.baseUrl}/dash_scores.php', data: {
        'patientId': widget.patientId,
        'answers': answersArray,
      });

      if (answersResponse.statusCode == 200) {
        final scoreData = {
          'patientId': widget.patientId,
          'dashScore': dashScore,
          'numberOfAnsweredItems': answersArray.length,
          'sumOfScores': sumOfScores,
          'difficultyCategory': difficultyCategory,
        };
        print('Submitting Score Data: $scoreData');

        final scoreResponse = await _dio.post('${Config.baseUrl}/insert_patient_score.php', data: scoreData);

        if (scoreResponse.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Answers and score submitted successfully.'),
            backgroundColor: Colors.green,
          ));

          // Navigate to PieChartScreen and pass the necessary data
          Navigator.pushNamed(context, '/PieChartScreen', arguments: {
            'patientId': widget.patientId,
            'dashScore': dashScore,
            'numberOfAnsweredItems': answersArray.length,
            'sumOfScores': sumOfScores,
            'difficultyCategory': difficultyCategory,
          }).then((_) {
            // Pop the current screen (QuestionnairesScreen1) after navigation
            Navigator.pop(context);
          });
        } else {
          print("Failed to submit DASH score");
        }
      } else {
        print("Failed to submit answers");
      }
    } catch (error) {
      print("Error submitting answers: $error");
    }
  }


  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (submissionStatus == 'submitted') {
      return Scaffold(
        appBar: AppBar(
          title: Text('Submission Status'),
          backgroundColor: Color(0xFF2DC2D7),
        ),
        body: Center(
          child: Text(
            'Your answers have already been submitted. Please wait $waitMessage',
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final startIndex = currentPage * questionsPerPage;
    final endIndex = (startIndex + questionsPerPage < questions.length) ? startIndex + questionsPerPage : questions.length;
    final currentQuestions = questions.sublist(startIndex, endIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Questionnaire'),
        backgroundColor: Color(0xFF2DC2D7),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: currentQuestions.length,
              itemBuilder: (context, index) {
                final question = currentQuestions[index];
                final questionText = question['question'];
                final questionOptionsList = optionsMap[int.parse(question['id'].toString())] ?? optionsMap[1];

                final questionNumber = startIndex + index + 1;

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$questionNumber. $questionText',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        ...questionOptionsList!.map((option) {
                          return RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: answers[questionText]?['option'],
                            onChanged: (value) {
                              handleOptionChange(questionText, value!);
                            },
                          );
                        }).toList(),
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
              if (currentPage > 0)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage--;
                    });
                  },
                  child: Text('Previous'),
                ),
              ElevatedButton(
                onPressed: handleSubmit,
                child: Text('Submit'),
              ),
              if (currentPage < (questions.length / questionsPerPage).ceil() - 1)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage++;
                    });
                  },
                  child: Text('Next'),
                ),
            ],
          ),
          if (submissionStatus == 'submitted')
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Your answers have already been submitted.',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }


  String getDifficultyCategory(double score) {
    if (score < 25) {
      return 'No difficulty';
    } else if (score < 50) {
      return 'Mild difficulty';
    } else if (score < 75) {
      return 'Moderate difficulty';
    } else if (score < 100) {
      return 'Severe difficulty';
    } else {
      return 'Unable';
    }
  }
}
