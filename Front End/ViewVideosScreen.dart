import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'config.dart';
import 'package:chewie/chewie.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Define the color constant
  static const Color primaryColor = Color(0xFF2DC2D7);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Videos',
      theme: ThemeData(
        primaryColor: primaryColor, // Set primary color for the theme
        fontFamily: 'Roboto', // Apply a custom font if available
      ),
    );
  }
}

class ViewVideosScreen extends StatefulWidget {
  final String patientId;

  const ViewVideosScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  _ViewVideosScreenState createState() => _ViewVideosScreenState();
}

class _ViewVideosScreenState extends State<ViewVideosScreen> with WidgetsBindingObserver {
  List videos = [];
  Map<int, ChewieController> chewieControllers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observe lifecycle events
    fetchVideos();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    // Dispose of all ChewieControllers and their VideoPlayerControllers
    chewieControllers.forEach((_, controller) {
      controller.videoPlayerController.pause(); // Pause before disposing
      controller.dispose();
    });
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    chewieControllers.forEach((_, controller) => controller.pause());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      chewieControllers.forEach((_, controller) => controller.pause());
    }
  }

  Future<void> fetchVideos() async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/selectedpatientvideos.php?patientId=${widget.patientId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] && data['videos'] != null) {
          setState(() {
            videos = data['videos']
                .where((video) => video['video_path'] != null && video['video_path'].endsWith('.mp4'))
                .toList();
          });
        } else {
          showError('No videos available for this patient.');
        }
      } else {
        showError('Failed to fetch videos: ${response.statusCode}');
      }
    } catch (e) {
      showError('An error occurred: $e');
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

  void openInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showError('Could not open URL');
    }
  }

  Widget buildVideoCard(int index) {
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

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
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
            SizedBox(height: 15),
            Text(
              video['custom_file_name'] ?? 'No title',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: MyApp.primaryColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2, // Limit the title to 2 lines, applying ellipsis for overflow
            ),
            SizedBox(height: 5),
            Text(
              'Introduction: ${video['introduction'] ?? ''}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 20, // Limit the introduction text to 20 lines, applying ellipsis for overflow
            ),
            SizedBox(height: 15),
            // Adjust the button's positioning (it will be at the bottom of the card)
            Align(
              alignment: Alignment.bottomLeft, // Start button at the bottom of the card
              child: ElevatedButton(
                onPressed: () {
                  // Open the video URL or appointment URL in the browser
                  openInBrowser(video['video_path']);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.08, // Adjusting button width based on screen size
                    vertical: 10,
                  ),
                  backgroundColor: MyApp.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Open in Browser',
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04), // Adjust text size based on screen size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Videos List'),
        backgroundColor: MyApp.primaryColor, // Use primary color here
      ),
      body: videos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return buildVideoCard(index);
        },
      ),
    );
  }
}
