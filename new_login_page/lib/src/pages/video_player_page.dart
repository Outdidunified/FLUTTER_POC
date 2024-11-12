import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AssetVideoPlayerScreen extends StatefulWidget {
  @override
  _AssetVideoPlayerScreenState createState() => _AssetVideoPlayerScreenState();
}

class _AssetVideoPlayerScreenState extends State<AssetVideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  // List of video file paths
  final List<String> videoFiles = [
    'assets/videos/video1.mp4',
    'assets/videos/video2.mp4',
    'assets/videos/video3.mp4',
    'assets/videos/video4.mp4',
  ];

  // Current video index
  int currentVideoIndex = -1;  // Initially no video is selected

  @override
  void initState() {
    super.initState();
  }

  // Method to initialize and play the selected video
  void _playVideo(int index) {
    setState(() {
      currentVideoIndex = index;
      _controller = VideoPlayerController.asset(videoFiles[currentVideoIndex]);
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.setLooping(true);
      _controller.setVolume(1.0);
      _controller.play();
    });
  }

  // Method to stop the video and reset the state
  void _stopVideo() {
    setState(() {
      _controller.pause(); // Pause the video
      _controller.seekTo(Duration.zero); // Reset to the start
      _controller.dispose(); // Dispose the controller to free resources
      currentVideoIndex = -1; // No video is selected now
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    if (currentVideoIndex != -1) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Player")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // If a video is selected, display it
            if (currentVideoIndex != -1)
              FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),

            // List of videos to select from
            Container(
              padding: EdgeInsets.all(10.0), // Add padding for better spacing
              child: Column(
                children: List.generate(videoFiles.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      // If the same video is clicked again, stop the video
                      if (currentVideoIndex == index) {
                        _stopVideo();
                      } else {
                        _playVideo(index);
                      }
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text('Video ${index + 1}'),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),

      // Play/Pause Button
      floatingActionButton: currentVideoIndex != -1
          ? FloatingActionButton(
        onPressed: () {
          setState(() {
            // If the video is playing, pause it, otherwise play it
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      )
          : null,
    );
  }
}
