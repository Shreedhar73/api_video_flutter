part of 'pick_video_bloc.dart';

abstract class PickVideoState extends Equatable {
  const PickVideoState();
}

class PickVideoInitial extends PickVideoState {
  @override
  List<Object> get props => [];
}

class VideoPickedState extends PickVideoState {
  final XFile pickedVideo;
  const VideoPickedState({required this.pickedVideo});

  @override
  List<Object?> get props => [pickedVideo];
}

class PickVideoError extends PickVideoState {
  @override
  List<Object> get props => [];
}
