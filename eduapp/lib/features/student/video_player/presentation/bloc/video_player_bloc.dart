import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'video_player_event.dart';
part 'video_player_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  VideoPlayerBloc() : super(VideoPlayerInitial()) {
    on<VideoPlayerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
