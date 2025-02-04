import 'dart:convert';

PexelsVideoResponse pexelsVideoResponseFromJson(String str) =>
    PexelsVideoResponse.fromJson(json.decode(str));

class PexelsVideoResponse {
  final int page;
  final int perPage;
  final List<Video> videos;
  final int totalResults;
  final String nextPage;
  final String url;

  PexelsVideoResponse({
    required this.page,
    required this.perPage,
    required this.videos,
    required this.totalResults,
    required this.nextPage,
    required this.url,
  });

  factory PexelsVideoResponse.fromJson(Map<String, dynamic> json) =>
      PexelsVideoResponse(
        page: json["page"],
        perPage: json["per_page"],
        videos: List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
        totalResults: json["total_results"],
        nextPage: json["next_page"],
        url: json["url"],
      );
}

class Video {
  final int id;
  final int width;
  final int height;
  final int duration;
  final String url;
  final String image;
  final User user;
  final List<VideoFile> videoFiles;
  final List<VideoPicture> videoPictures;
  int likes;
  int comments;
  final bool isLiked;

  Video({
    required this.id,
    required this.width,
    required this.height,
    required this.duration,
    required this.url,
    required this.image,
    required this.user,
    required this.videoFiles,
    required this.videoPictures,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: json["id"],
    width: json["width"],
    height: json["height"],
    duration: json["duration"],
    url: json["url"],
    image: json["image"],
    user: User.fromJson(json["user"]),
    videoFiles: List<VideoFile>.from(
        json["video_files"].map((x) => VideoFile.fromJson(x))),
    videoPictures: List<VideoPicture>.from(
        json["video_pictures"].map((x) => VideoPicture.fromJson(x))),
  );

  /// `copyWith` method to create a new instance with updated values
  Video copyWith({
    int? likes,
    int? comments,
    bool? isLiked,  // Allow the isLiked property to be updated
  }) {
    return Video(
      id: id,
      width: width,
      height: height,
      duration: duration,
      url: url,
      image: image,
      user: user,
      videoFiles: videoFiles,
      videoPictures: videoPictures,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked, // Update the isLiked property
    );
  }
}



class User {
  final int id;
  final String name;
  final String url;

  User({
    required this.id,
    required this.name,
    required this.url,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    url: json["url"],
  );
}

class VideoFile {
  final int id;
  final String quality;
  final String fileType;
  final int width;
  final int height;
  final double fps;
  final String link;
  final int size;

  VideoFile({
    required this.id,
    required this.quality,
    required this.fileType,
    required this.width,
    required this.height,
    required this.fps,
    required this.link,
    required this.size,
  });

  factory VideoFile.fromJson(Map<String, dynamic> json) => VideoFile(
    id: json["id"],
    quality: json["quality"],
    fileType: json["file_type"],
    width: json["width"],
    height: json["height"],
    fps: json["fps"].toDouble(),
    link: json["link"],
    size: json["size"],
  );
}

class VideoPicture {
  final int id;
  final int nr;
  final String picture;

  VideoPicture({
    required this.id,
    required this.nr,
    required this.picture,
  });

  factory VideoPicture.fromJson(Map<String, dynamic> json) => VideoPicture(
    id: json["id"],
    nr: json["nr"],
    picture: json["picture"],
  );
}
