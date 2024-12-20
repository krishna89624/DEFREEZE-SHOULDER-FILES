import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'config.dart';

class AddVideoDetailsScreen extends StatefulWidget {
  final String doctorId;
  final String patientId;

  const AddVideoDetailsScreen({
    Key? key,
    required this.doctorId,
    required this.patientId,
  }) : super(key: key);

  @override
  _AddVideoDetailsScreenState createState() => _AddVideoDetailsScreenState();
}

class _AddVideoDetailsScreenState extends State<AddVideoDetailsScreen> with WidgetsBindingObserver {
  List videos = [];
  bool loading = false;
  Map<int, ChewieController> chewieControllers = {};
  Set<int> selectedVideos = {}; // Track selected videos

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observe lifecycle events
    fetchVideos();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    chewieControllers.forEach((_, controller) {
      controller.videoPlayerController.pause(); // Pause before disposing
      controller.dispose();
    });
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      chewieControllers.forEach((_, controller) => controller.pause());
    }
  }

  Future<void> fetchVideos() async {
    setState(() {
      loading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/displayvideosdoctor.php?doctorId=${widget.doctorId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            videos = data;
          });
        } else {
          showError('No videos are available for this doctor.');
        }
      } else {
        showError('Failed to load videos: ${response.statusCode}');
      }
    } catch (e) {
      showError('An error occurred: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _openInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showError("Couldn't open the video in the browser.");
    }
  }

  Future<void> saveSelectedVideos() async {
    // Prepare the list of selected video details with explicit casting
    List<Map<String, String>> selectedVideoDetails = selectedVideos.map((index) {
      final video = videos[index];
      return {
        'video_path': video['video_path'] as String,
        'introduction': (video['introduction'] ?? '') as String,
        'custom_file_name': (video['custom_file_name'] ?? 'Untitled') as String,
      };
    }).toList();

    // Prepare the data payload
    final payload = {
      'doctorId': widget.doctorId,
      'patientId': widget.patientId,
      'selectedVideos': selectedVideoDetails,
    };

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/selectedvideosdoc.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success']) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Success'),
              content: Text('Videos saved successfully'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Navigate back
                  },
                ),
              ],
            ),
          );
        } else {
          showError('Failed to save videos');
        }
      } else {
        showError('Failed to save videos: ${response.statusCode}');
      }
    } catch (e) {
      showError('An error occurred while saving videos: $e');
    }
  }

  Widget buildVideoCard(int index, double screenWidth) {
    final video = videos[index];
    if (!chewieControllers.containsKey(index)) {
      final videoController = VideoPlayerController.network(video['video_path']);
      final chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: false,
        looping: false,
        errorBuilder: (context, error) {
          return Center(child: Text('Error playing video: $error'));
        },
      );
      chewieControllers[index] = chewieController;
    }

    double cardPadding = screenWidth * 0.05; // 5% of screen width for padding
    double cardElevation = screenWidth * 0.02; // Dynamic elevation based on screen width

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: cardElevation,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: cardPadding),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Chewie(controller: chewieControllers[index]!),
              ),
            ),
            SizedBox(height: screenWidth * 0.05), // Vertical space based on screen width
            Text(
              video['custom_file_name'] ?? 'No title',
              style: TextStyle(
                fontSize: screenWidth * 0.045, // Font size based on screen width
                fontWeight: FontWeight.w600,
                color: Color(0xFF2DC2D7),
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Introduction: ${video['introduction'] ?? ''}',
              style: TextStyle(
                fontSize: screenWidth * 0.035, // Font size based on screen width
                color: Colors.grey[600],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _openInBrowser(video['video_path']),
                  child: Text('Open in Browser'),
                ),
                Checkbox(
                  value: selectedVideos.contains(index),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedVideos.add(index);
                      } else {
                        selectedVideos.remove(index);
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Videos List'),
        backgroundColor: Color(0xFF2DC2D7),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveSelectedVideos,
          ),
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : videos.isEmpty
          ? Center(child: Text('No videos available.'))
          : ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return buildVideoCard(index, screenWidth);
        },
      ),
    );
  }
}
