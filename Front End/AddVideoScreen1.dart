import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'config.dart'; // Import your config file for baseUrl
import 'AddVideoDetailsScreen.dart'; // Import the new screen

class AddVideoScreen1 extends StatefulWidget {
  final String doctorId;
  final String patientId;

  AddVideoScreen1({
    required this.doctorId,
    required this.patientId,
  });

  @override
  _AddVideoScreen1State createState() => _AddVideoScreen1State();
}

class _AddVideoScreen1State extends State<AddVideoScreen1> with WidgetsBindingObserver {
  List videos = [];
  bool loading = true;
  String? error;
  final Map<int, ChewieController> chewieControllers = {};

  @override
  void initState() {
    super.initState();
    fetchVideos();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> fetchVideos() async {
    setState(() {
      loading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/selectedpatientvideos.php?patientId=${widget.patientId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            videos = data['videos'];
            error = null;
          });
        } else {
          setState(() {
            error = data['message'];
          });
        }
      } else {
        setState(() {
          error = 'Failed to fetch videos. Please try again later.';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to fetch videos. Please try again later.';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    chewieControllers.forEach((_, controller) {
      controller.videoPlayerController.pause();
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

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: screenWidth * 0.05), // Responsive margin
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
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
                fontSize: screenWidth * 0.05, // Responsive font size
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2DC2D7),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              'Introduction: ${video['introduction'] ?? ''}',
              style: TextStyle(
                fontSize: screenWidth * 0.04, // Responsive font size
                color: Colors.grey[600],
              ),
              maxLines: 20,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => openInBrowser(video['video_path']),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 10),
                    backgroundColor: const Color(0xFFffffff),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Open in Browser',
                    style: TextStyle(fontSize: screenWidth * 0.03),
                  ),
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
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Videos for Patient'),
        backgroundColor: const Color(0xFF2DC2D7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: loading
            ? Center(child: CircularProgressIndicator())
            : error != null
            ? Center(child: Text(error!))
            : ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return buildVideoCard(index, screenWidth);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddVideoDetailsScreen(
                doctorId: widget.doctorId,
                patientId: widget.patientId,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: const Color(0xFF2DC2D7),
      ),
    );
  }
}
