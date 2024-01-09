part of 'list_video_bloc.dart';

abstract class ListVideoState extends Equatable {
  const ListVideoState();
}

class ListVideoInitial extends ListVideoState {
  @override
  List<Object> get props => [];
}

class VideoListLoading extends ListVideoState {
  @override
  List<Object> get props => [];
}

class VideoListLoaded extends ListVideoState {
  final List<VideoModel> videoList;
  const VideoListLoaded({required this.videoList});
  @override
  List<Object> get props => [videoList];
}

class VideoListError extends ListVideoState {
  @override
  List<Object> get props => [];
}
