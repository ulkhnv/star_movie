import 'package:dio/dio.dart';
import 'package:star_movie/src/data/constants/constants.dart';
import 'package:star_movie/src/data/interceptors/api_key_interceptor.dart';
import 'package:star_movie/src/data/models/movie_cover_model.dart';
import 'package:star_movie/src/domain/entities/enums/movie_cover_category.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieCoverModel>> getMovieCovers(
      MovieCoverCategory category, int page);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  MovieRemoteDataSourceImpl({
    required this.dio,
  }) {
    dio.interceptors.add(ApiKeyInterceptor());
  }

  final Dio dio;

  @override
  Future<List<MovieCoverModel>> getMovieCovers(
      MovieCoverCategory category, int page) {
    switch (category) {
      case MovieCoverCategory.nowShowing:
        return _getMovies(NOW_SHOWING_API_PATH, page);
      case MovieCoverCategory.upcoming:
        return _getMovies(UPCOMING_API_PATH, page);
    }
  }

  Future<List<MovieCoverModel>> _getMovies(String path, int page) async {
    try {
      final response = await dio.get('$BASE_MOVIE_URL/$path?page=$page');
      if (response.statusCode == 200) {
        return (response.data['results'] as List)
            .map((e) => MovieCoverModel.fromJson(e))
            .toList();
      } else {
        throw Exception('Error while fetching movies: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio Error: ${e.message}');
    }
  }
}
