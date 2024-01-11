import 'package:api_video/commons/video_controller.dart';
import 'package:api_video/commons/widgets/static_progress_bar.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key, required this.path, this.isLocal = true});

  /// this is url in case of remote and path in case of local
  final String path;
  final bool isLocal;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  final videoController = VideoController();

  @override
  void initState() {
    videoController.initializeController(
        videoUrl: widget.path, isLocal: widget.isLocal);
    super.initState();
  }

  @override
  void dispose() {
    videoController.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoPlayer(
          videoController.controller!,
        ),
        Positioned(
          top: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: StaticProgressBar(
              value: videoController.controller!.value,
              barHeight: 5,
              handleHeight: 3,
            ),
          ),
          // child: ProgressBar(progress: progress, total: total),
        ),
        Align(
          alignment: Alignment.center,
          child: InkWell(
            onTap: () {
              if (videoController.controller!.value.isPlaying) {
                videoController.pauseVideo();
              } else {
                videoController.playVideo();
              }
              setState(() {});
            },
            child: Icon(
              videoController.controller!.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
