import 'package:api_video/features/home_page/data/video_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDetails extends StatefulWidget {
  const VideoDetails({super.key, required this.videoData});
  final VideoModel videoData;

  @override
  State<VideoDetails> createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {
  late VideoPlayerController controller;

  @override
  void initState() {
    controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoData.asset?.videoUrl ?? ''));
    controller.initialize();

    controller.play();

    super.initState();
  }

  @override
  void dispose() {
    controller.pause();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      appBar: AppBar(
        title: Text(widget.videoData.title ?? ''),
        backgroundColor: Colors.grey.withOpacity(0.2),
      ),
      body: SizedBox(
          width: MediaQuery.of(
                context,
              ).size.width *
              1,
          child: VideoPlayer(controller)),
    );
  }
}
