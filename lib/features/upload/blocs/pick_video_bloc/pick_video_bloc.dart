import 'package:api_video/features/upload/data/pick_video/pick_video_datasource.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'pick_video_event.dart';
part 'pick_video_state.dart';

class PickVideoBloc extends Bloc<PickVideoEvent, PickVideoState> {
  PickVideoBloc() : super(PickVideoInitial()) {
    on<PickLocalVideoEvent>((event, emit) async {
      final pickVideo = await PickALocalVideo().pickAVideo();
      if (pickVideo is XFile) {
        emit(VideoPickedState(pickedVideo: pickVideo));
      } else {
        emit(PickVideoError());
      }
    });
  }
}
