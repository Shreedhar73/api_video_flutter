part of 'pick_video_bloc.dart';

abstract class PickVideoState extends Equatable {
  const PickVideoState();
}

class PickVideoInitial extends PickVideoState {
  @override
  List<Object> get props => [];
}

class VideoPickedState extends PickVideoState {
  final List<XFile> pickedVideos;
  const VideoPickedState({required this.pickedVideos});

  @override
  List<Object?> get props => [pickedVideos];
}

class PickVideoError extends PickVideoState {
  @override
  List<Object> get props => [];
}
