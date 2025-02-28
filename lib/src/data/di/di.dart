import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_movie/src/data/datasources/genre_local_datasource.dart';
import 'package:star_movie/src/data/datasources/genre_remote_datasource.dart';
import 'package:star_movie/src/data/datasources/movie_local_datasource.dart';
import 'package:star_movie/src/data/datasources/movie_remote_datasource.dart';
import 'package:star_movie/src/data/mappers/movie_mapper.dart';
import 'package:star_movie/src/data/repositories/movie_repository_impl.dart';
import 'package:star_movie/src/domain/repositories/movie_repository.dart';

Future<void> initDataDependencies(GetIt getIt) async {
  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      movieRemoteDataSource: getIt(),
      movieLocalDataSource: getIt(),
      genreRemoteDataSource: getIt(),
      genreLocalDataSource: getIt(),
      movieMapper: getIt(),
    ),
  );

  getIt.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  getIt.registerLazySingleton<GenreRemoteDataSource>(
    () => GenreRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<GenreLocalDataSource>(
    () => GenreLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  getIt.registerLazySingleton<MovieMapper>(
    () => MovieMapperImpl(),
  );

  getIt.registerLazySingleton(
    () => Dio(),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
}
