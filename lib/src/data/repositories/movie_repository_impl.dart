import 'package:star_movie/src/data/datasources/genre_local_datasource.dart';
import 'package:star_movie/src/data/datasources/genre_remote_datasource.dart';
import 'package:star_movie/src/data/datasources/movie_local_datasource.dart';
import 'package:star_movie/src/data/datasources/movie_remote_datasource.dart';
import 'package:star_movie/src/data/mappers/movie_mapper.dart';
import 'package:star_movie/src/data/models/genre_model.dart';
import 'package:star_movie/src/data/models/movie_cover_model.dart';
import 'package:star_movie/src/domain/entities/movie_cover.dart';
import 'package:star_movie/src/domain/repositories/movie_repository.dart';
import 'package:star_movie/src/domain/usecases/movie_cover_params.dart';

class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl({
    required this.movieRemoteDataSource,
    required this.movieLocalDataSource,
    required this.genreRemoteDataSource,
    required this.genreLocalDataSource,
    required this.movieMapper,
  });

  final MovieRemoteDataSource movieRemoteDataSource;
  final MovieLocalDataSource movieLocalDataSource;
  final GenreRemoteDataSource genreRemoteDataSource;
  final GenreLocalDataSource genreLocalDataSource;
  final MovieMapper movieMapper;

  @override
  Future<List<MovieCover>> getMovieCovers(MovieCoverParams params) async {
    if (params.page == 1 &&
        !params.forceUpdate &&
        await _shouldUseCachedData()) {
      final cachedMovies =
          await movieLocalDataSource.getMovieCovers(params.movieCoverCategory);
      if (cachedMovies.isNotEmpty) {
        return _mapToMovieCover(cachedMovies);
      }
    }

    final remoteMovies = await movieRemoteDataSource.getMovieCovers(
      params.movieCoverCategory,
      params.page,
    );

    if (params.page == 1) {
      await movieLocalDataSource.setMovieCovers(
          params.movieCoverCategory, remoteMovies);
      await movieLocalDataSource.setLastUpdate(DateTime.now());
    }

    return _mapToMovieCover(remoteMovies);
  }

  Future<bool> _shouldUseCachedData() async {
    final lastUpdate = await movieLocalDataSource.getLastUpdate();
    return lastUpdate != null &&
        DateTime.now().difference(lastUpdate).inDays < 1;
  }

  Future<List<MovieCover>> _mapToMovieCover(
      List<MovieCoverModel> movies) async {
    var genresMap = await _getCachedGenres();

    final missingIds = movies
        .expand((movie) => movie.genreIds)
        .where((id) => !genresMap.containsKey(id))
        .toSet();

    if (missingIds.isNotEmpty) {
      genresMap = await _updateLocalGenres();
    }

    return movies.map((model) {
      final genreNames =
          model.genreIds.map((id) => genresMap[id]?.name ?? 'Unknown').toList();
      return movieMapper.toMovieCover(model, genreNames);
    }).toList();
  }

  Future<Map<int, GenreModel>> _getCachedGenres() async {
    final cachedGenres = await genreLocalDataSource.getGenres();
    return {for (var genre in cachedGenres) genre.id: genre};
  }

  Future<Map<int, GenreModel>> _updateLocalGenres() async {
    final genres = await genreRemoteDataSource.getGenres();
    await genreLocalDataSource.setGenres(genres);
    return {for (var genre in genres) genre.id: genre};
  }
}
