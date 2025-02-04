import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart'; // Add this package for video playback
import 'package:instashorts/presentation/bloc/video_bloc.dart';


import '../../data/models/api_modal.dart';

class VideoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "InstaReels",
          style: GoogleFonts.fredoka(
            fontWeight: FontWeight.w500, // Instagram uses bold text for the title
            fontSize: 24, // Adjust size if needed
            color: Colors.white
          ),
        ),
      ),

      body: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          if (state is VideoLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is VideoLoaded) {
            return VideoList(videos: state.videos);
          } else {
            return Center(child: Text("Failed to load videos."));
          }
        },
      ),
    );
  }
}

class VideoList extends StatefulWidget {
  final List<Video> videos;

  VideoList({required this.videos});

  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: widget.videos.length,
      itemBuilder: (context, index) {
        return VideoPlayerItem(video: widget.videos[index]);
      },
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final Video video;

  VideoPlayerItem({required this.video});

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.video.videoFiles.first.link);
    _initializeVideoPlayerFuture = _videoController.initialize().then((_) {
      _videoController.play();
      _videoController.setLooping(true);
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              // Video Player
              SizedBox.expand(
                child: AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                ),
              ),

              // Like, Comment, Share Buttons (Instagram-style)
              Positioned(
                bottom: 30,
                right: 20,
                child: Column(
                  children: [
                    // Like Button
                    BlocBuilder<VideoBloc, VideoState>(
                      builder: (context, state) {
                        if (state is VideoLoaded) {
                          final video = state.videos.firstWhere((v) => v.id == widget.video.id);
                          return Column(
                            children: [
                              IconButton(
                          icon: Icon(
                          video.isLiked ? Icons.favorite : Icons.favorite_border, // Filled if liked, otherwise outlined
                            color: video.isLiked ? Colors.red : Colors.white, // Red if liked, otherwise white
                          ),

                          onPressed: () {
                                  context.read<VideoBloc>().add(LikeVideo(video.id));
                                },
                              ),

                              Text(
                                "${video.likes}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          );
                        }
                        return Container();
                      },
                    ),

                    SizedBox(height: 20),

                    // Comment Button
                    BlocBuilder<VideoBloc, VideoState>(
                      builder: (context, state) {
                        if (state is VideoLoaded) {
                          final video = state.videos.firstWhere((v) => v.id == widget.video.id);
                          return Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.comment, color: Colors.white),
                                onPressed: () {
                                  context.read<VideoBloc>().add(AddComment(widget.video.id));
                                },
                              ),
                              Text(
                                "${video.comments}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          );
                        }
                        return Container();
                      },
                    ),

                    SizedBox(height: 20),

                    // Share Button
                    IconButton(
                      icon: Icon(Icons.share, color: Colors.white),
                      onPressed: () async {
                        await Share.share(
                          widget.video.videoFiles.first.link,
                          subject: 'Check out this video!',
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Video Info (Bottom Left)
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Video ID: ${widget.video.id}",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "${widget.video.likes} likes",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "${widget.video.comments} comments",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}