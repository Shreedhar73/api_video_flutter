import 'package:api_video/commons/widgets/video_player_widget.dart';
import 'package:api_video/features/pick_video/blocs/pick_video_bloc/pick_video_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoPickedWidget extends StatelessWidget {
  const VideoPickedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: Colors.black,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: BlocBuilder<PickVideoBloc, PickVideoState>(
            builder: (context, state) {
          if (state is VideoPickedState) {
            return VideoPlayerWidget(
              path: state.pickedVideos.first.path,
            );
          } else {
            return InkWell(
              onTap: () {
                context.read<PickVideoBloc>().add(PickLocalVideoEvent());
              },
              child: const Text(
                'Click here to Pick Video',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        }),
      ),
    );
  }
}
