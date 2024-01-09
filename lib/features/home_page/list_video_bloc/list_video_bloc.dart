import 'package:api_video/features/home_page/data/list_data_source.dart';
import 'package:api_video/features/home_page/data/video_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'list_video_event.dart';
part 'list_video_state.dart';

class ListVideoBloc extends Bloc<ListVideoEvent, ListVideoState> {
  ListVideoBloc() : super(ListVideoInitial()) {
    on<ListVideoEvent>((event, emit) async {
      emit(VideoListLoading());
      final videoList = await ListAllVideos().getAllVideos();
      if (videoList is List<VideoModel>) {
        emit(VideoListLoaded(videoList: videoList));
      } else {
        emit(VideoListError());
      }
    });
  }
}
