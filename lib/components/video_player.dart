import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

typedef VideoEndCallback = void Function();

class LocalVideoPlayer extends StatefulWidget {
  final VideoEndCallback? onVideoEnd;
  const LocalVideoPlayer({super.key, this.onVideoEnd});

  @override
  State<LocalVideoPlayer> createState() => _LocalVideoPlayerState();
}

class _LocalVideoPlayerState extends State<LocalVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Load video from assets
    _controller = VideoPlayerController.asset("assets/video/sample_video.mp4")
      ..initialize().then((_) {
        setState(() {}); // Refresh to show video
        _controller.play();
      });
    _controller.addListener(_videoListener);
  }

  void _videoListener() {
    if (_controller.value.position >= _controller.value.duration && _controller.value.isInitialized) {
      widget.onVideoEnd?.call();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose(); // Clean up
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _controller.value.isInitialized ? AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller)) : const CircularProgressIndicator()),
    );
  }
}
