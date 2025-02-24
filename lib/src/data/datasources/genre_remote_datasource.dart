import 'package:dio/dio.dart';
import 'package:star_movie/src/data/constants/constants.dart';
import 'package:star_movie/src/data/interceptors/api_key_interceptor.dart';
import 'package:star_movie/src/data/models/genre_model.dart';

abstract class GenreRemoteDataSource {
  Future<List<GenreModel>> getGenres();
}

class GenreRemoteDataSourceImpl implements GenreRemoteDataSource {
  GenreRemoteDataSourceImpl({
    required this.dio,
  }) {
    dio.interceptors.add(ApiKeyInterceptor());
  }

  final Dio dio;

  @override
  Future<List<GenreModel>> getGenres() async {
    try {
      final response = await dio.get(BASE_GENRE_URL);
      if (response.statusCode == 200) {
        return (response.data['genres'] as List)
            .map((e) => GenreModel.fromJson(e))
            .toList();
      } else {
        throw Exception('Error while fetching genres: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio Error: ${e.message}');
    }
  }
}
