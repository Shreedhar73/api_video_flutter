import 'package:api_video/commons/video_controller.dart';
import 'package:api_video/commons/widgets/static_progress_bar.dart';
import 'package:api_video/commons/widgets/video_player_widget.dart';
import 'package:api_video/features/home_page/data/video_model.dart';
import 'package:flutter/material.dart';

class VideoDetails extends StatefulWidget {
  const VideoDetails({super.key, required this.videoData});
  final VideoModel videoData;

  @override
  State<VideoDetails> createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {
  late List<Chapter> chapters;
  @override
  void initState() {
    chapters = widget.videoData.chapters ?? [];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      floatingActionButton: FloatingActionButton(onPressed: () {
        VideoController().controller?.seekTo(
            Duration(seconds: convertToSeconds(chapters[2].startTime)));
        // showModalBottomSheet(
        //     context: context,
        //     builder: (ctx) => SizedBox(height: 300, child: chaptersWidget()));
      }),
      appBar: AppBar(
        title: Text(widget.videoData.title ?? ''),
        backgroundColor: Colors.grey.withOpacity(0.2),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: 600,
              child: VideoPlayerWidget(
                path: widget.videoData.asset?.videoUrl ?? '',
                isLocal: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chaptersWidget() {
    return ListView.builder(
        itemCount: chapters.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            title: Text(chapters[index].title),
            onTap: () {
              VideoController()
                  .controller
                  ?.seekTo(Duration(
                      seconds: convertToSeconds(chapters[index].startTime)))
                  .then((value) => setState(() {}));
            },
          );
        });
  }

  int convertToSeconds(String data) {
    List<String> parts = data.split(':');
    int minutes = int.parse(parts[0]);
    List<String> secondsAndMillis = parts[1].split('.');
    int seconds = int.parse(secondsAndMillis[0]);
    int milliseconds = int.parse(secondsAndMillis[1]);

    // Convert to seconds
    return (minutes * 60 + seconds + milliseconds / 1000).toInt();
  }
}
