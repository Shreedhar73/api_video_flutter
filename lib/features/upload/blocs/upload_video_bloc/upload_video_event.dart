part of 'upload_video_bloc.dart';

abstract class UploadVideoEvent extends Equatable {
  const UploadVideoEvent();
}

class UploadLocalVideoEvent extends UploadVideoEvent {
  final XFile file;
  const UploadLocalVideoEvent({required this.file});
  @override
  List<Object> get props => [];
}
