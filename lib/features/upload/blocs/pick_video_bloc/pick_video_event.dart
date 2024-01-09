part of 'pick_video_bloc.dart';

abstract class PickVideoEvent extends Equatable {
  const PickVideoEvent();

  @override
  List<Object> get props => [];
}

class PickLocalVideoEvent extends PickVideoEvent {}
