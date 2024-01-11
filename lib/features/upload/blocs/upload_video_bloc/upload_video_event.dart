part of 'upload_video_bloc.dart';

abstract class UploadVideoEvent extends Equatable {
  const UploadVideoEvent();
}

class UploadLocalVideoEvent extends UploadVideoEvent {
  final UploadLocalVideoParams fileParams;
  const UploadLocalVideoEvent({required this.fileParams});
  @override
  List<Object> get props => [fileParams];
}

class UploadLocalVideoParams {
  final XFile file;
  final String title;
  final String description;

  UploadLocalVideoParams({
    required this.file,
    required this.title,
    required this.description,
  });
}
