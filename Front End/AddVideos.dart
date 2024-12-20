import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'config.dart';
import 'Addvideosscreen.dart';

class AddVideos extends StatefulWidget {
  final String doctorId;

  const AddVideos({Key? key, required this.doctorId}) : super(key: key);

  @override
  _AddVideosState createState() => _AddVideosState();
}

class _AddVideosState extends State<AddVideos> with WidgetsBindingObserver {
  List videos = [];
  bool loading = false;
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
                color: Color(0xFF2DC2D7),
              ),
              maxLines: 1,  // Limit the title to one line
              overflow: TextOverflow.ellipsis,  // Add ellipsis if overflow
            ),
            SizedBox(height: 5),
            Text(
              'Introduction: ${video['introduction'] ?? ''}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              maxLines: 20,  // Limit the introduction to one line
              overflow: TextOverflow.ellipsis,  // Add ellipsis if overflow
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _openInBrowser(video['video_path']),
              child: Text('Open in Browser'),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToAddVideoScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Addvideosscreen(doctorId: widget.doctorId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Videos List'),
        backgroundColor: Color(0xFF2DC2D7),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : videos.isEmpty
          ? Center(child: Text('No videos available.'))
          : ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return buildVideoCard(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddVideoScreen,
        backgroundColor: Color(0xFF2DC2D7),
        child: Icon(Icons.add),
      ),
    );
  }
}
