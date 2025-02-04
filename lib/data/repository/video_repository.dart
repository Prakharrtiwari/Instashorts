import 'package:dio/dio.dart';
import 'package:instashorts/data/models/api_modal.dart';
import 'package:instashorts/data/networkServices/api_service.dart';


class VideoRepository {
  final PexelsApiService apiService;

  VideoRepository(this.apiService);

  Future<List<Video>> fetchVideos() async {
    final response = await apiService.getPopularVideos(
      "Y6yzPG5dsCDftzJUwGtSFiiw5qHa7cjAaUNiPqMQ6V5gwd8xAakfmDUE",
      20, // Number of videos per page
    );
    return response.videos;
  }
}
