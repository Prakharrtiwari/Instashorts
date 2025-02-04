import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instashorts/data/models/api_modal.dart';
import 'package:instashorts/data/repository/video_repository.dart';


// Video Events
abstract class VideoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchVideos extends VideoEvent {}

class LikeVideo extends VideoEvent {
  final int videoId;
  LikeVideo(this.videoId);

  @override
  List<Object?> get props => [videoId];
}

class AddComment extends VideoEvent {
  final int videoId;
  AddComment(this.videoId);

  @override
  List<Object?> get props => [videoId];
}

// Video States
abstract class VideoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final List<Video> videos;
  VideoLoaded(this.videos);

  @override
  List<Object?> get props => [videos];
}

class VideoError extends VideoState {}

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoRepository videoRepository;

  VideoBloc(this.videoRepository) : super(VideoLoading()) {
    on<FetchVideos>((event, emit) async {
      try {
        final videos = await videoRepository.fetchVideos();
        emit(VideoLoaded(videos));
      } catch (e) {
        emit(VideoError());
      }
    });

    on<LikeVideo>((event, emit) {
      if (state is VideoLoaded) {
        final updatedVideos = (state as VideoLoaded).videos.map((video) {
          if (video.id == event.videoId) {
            return video.copyWith(
              likes: video.isLiked ? video.likes - 1 : video.likes + 1, // Increment or decrement likes
              isLiked: !video.isLiked, // Toggle isLiked status
            );
          }
          return video;
        }).toList();
        emit(VideoLoaded(updatedVideos));
      }
    });



    on<AddComment>((event, emit) {
      if (state is VideoLoaded) {
        final updatedVideos = (state as VideoLoaded).videos.map((video) {
          if (video.id == event.videoId) {
            return video.copyWith(comments: video.comments + 1);
          }
          return video;
        }).toList();
        emit(VideoLoaded(updatedVideos));
      }
    });
  }
}
