import 'package:api_video/features/upload/data/upload_video_datasource/upload_video_datasource.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_uploader/video_uploader.dart';

part 'upload_video_event.dart';
part 'upload_video_state.dart';

class UploadVideoBloc extends Bloc<UploadVideoEvent, UploadVideoState> {
  UploadVideoBloc() : super(UploadVideoInitial()) {
    on<UploadLocalVideoEvent>((event, emit) async {
      emit(UploadVideoLoading());
      final uploadVideo = await UploadVideoDataSource().uploadVideo(event.file);
      if (uploadVideo is Video) {
        emit(UploadVideoSuccess(video: uploadVideo));
      } else {
        emit(UploadVideoError());
      }
    });
  }
}
