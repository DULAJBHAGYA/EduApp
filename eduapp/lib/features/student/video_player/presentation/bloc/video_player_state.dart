part of 'video_player_bloc.dart';

sealed class VideoPlayerState extends Equatable {
  const VideoPlayerState();
  
  @override
  List<Object> get props => [];
}

final class VideoPlayerInitial extends VideoPlayerState {}
