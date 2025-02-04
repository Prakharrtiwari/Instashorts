import 'package:dio/dio.dart';
import 'package:instashorts/data/models/api_modal.dart';
import 'package:retrofit/error_logger.dart';

import 'package:retrofit/http.dart';


part 'api_service.g.dart';

@RestApi(baseUrl: "https://api.pexels.com/videos/")
abstract class PexelsApiService {
  factory PexelsApiService(Dio dio, {String baseUrl}) = _PexelsApiService;

  @GET("popular")
  Future<PexelsVideoResponse> getPopularVideos(
      @Header("Authorization") String apiKey,
      @Query("per_page") int perPage,
      );
}
