import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'config.dart'; // Import your config file for baseUrl

class Addvideosscreen extends StatefulWidget {
  final String doctorId;

  Addvideosscreen({Key? key, required this.doctorId}) : super(key: key);

  @override
  _AddvideosscreenState createState() => _AddvideosscreenState();
}

class _AddvideosscreenState extends State<Addvideosscreen> {
  final TextEditingController _introductionController = TextEditingController();
  final TextEditingController _customFileNameController = TextEditingController();
  File? _videoFile;
  VideoPlayerController? _videoPlayerController;

  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
        _videoPlayerController = VideoPlayerController.file(_videoFile!)
          ..initialize().then((_) {
            setState(() {});
          });
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (_videoFile == null) return;

    final uri = Uri.parse("${Config.baseUrl}/doctorvideo.php"); // Use Config class
    final request = http.MultipartRequest("POST", uri);

    request.fields['introduction'] = _introductionController.text;
    request.fields['custom_file_name'] = _customFileNameController.text;
    request.fields['doctorId'] = widget.doctorId;
    request.files.add(await http.MultipartFile.fromPath('video_file', _videoFile!.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Video uploaded successfully: ${responseData.body}"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error uploading video: ${response.reasonPhrase}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Video"),
        backgroundColor: Color(0xFF2DC2D7),
      ),
      body: SingleChildScrollView(  // Wrap with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _introductionController,
                decoration: InputDecoration(
                  labelText: "Introduction",
                  labelStyle: TextStyle(color: Color(0xFF2DC2D7)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2DC2D7), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2DC2D7), width: 1),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _customFileNameController,
                decoration: InputDecoration(
                  labelText: "Custom File Name",
                  labelStyle: TextStyle(color: Color(0xFF2DC2D7)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2DC2D7), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2DC2D7), width: 1),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickVideo,
                child: Text("Pick Video"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2DC2D7),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_videoFile != null && _videoPlayerController != null && _videoPlayerController!.value.isInitialized)
                Column(
                  children: [
                    Container(
                      height: 200,
                      child: VideoPlayer(_videoPlayerController!),
                    ),
                    VideoProgressIndicator(_videoPlayerController!, allowScrubbing: true),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _videoPlayerController!.value.isPlaying
                              ? _videoPlayerController!.pause()
                              : _videoPlayerController!.play();
                        });
                      },
                      child: Icon(
                        _videoPlayerController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2DC2D7),
                        foregroundColor: Colors.white,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadVideo,
                child: Text("Upload Video"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2DC2D7),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
