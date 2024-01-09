part of 'upload_video_bloc.dart';

abstract class UploadVideoState extends Equatable {
  const UploadVideoState();
}

class UploadVideoInitial extends UploadVideoState {
  @override
  List<Object> get props => [];
}

class UploadVideoLoading extends UploadVideoState {
  @override
  List<Object> get props => [];
}

class UploadVideoSuccess extends UploadVideoState {
  final Video video;
  const UploadVideoSuccess({required this.video});
  @override
  List<Object> get props => [video];
}

class UploadVideoError extends UploadVideoState {
  @override
  List<Object> get props => [];
}
