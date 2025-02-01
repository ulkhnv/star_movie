import 'package:dio/dio.dart';
import 'package:star_movie/src/data/constants/constants.dart';
import 'package:star_movie/src/data/interceptors/api_key_interceptor.dart';
import 'package:star_movie/src/data/models/movie_cover_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieCoverModel>> getNowShowingMovies();

  Future<List<MovieCoverModel>> getUpcomingMovies();
}

class MovieRemoteDataSourceImpl extends MovieRemoteDataSource {
  MovieRemoteDataSourceImpl({
    required this.dio,
  }) {
    dio.interceptors.add(ApiKeyInterceptor());
  }

  final Dio dio;

  @override
  Future<List<MovieCoverModel>> getNowShowingMovies() async {
    return _getMovies('now_playing');
  }

  @override
  Future<List<MovieCoverModel>> getUpcomingMovies() {
    return _getMovies('upcoming');
  }

  Future<List<MovieCoverModel>> _getMovies(String path) async {
    try {
      final response = await dio.get('$baseMovieUrl/$path');
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
