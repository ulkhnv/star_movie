import 'package:star_movie/src/data/datasources/genre_local_datasource.dart';
import 'package:star_movie/src/data/datasources/genre_remote_datasource.dart';
import 'package:star_movie/src/data/datasources/movie_local_datasource.dart';
import 'package:star_movie/src/data/datasources/movie_remote_datasource.dart';
import 'package:star_movie/src/data/mappers/movie_mapper.dart';
import 'package:star_movie/src/data/models/genre_model.dart';
import 'package:star_movie/src/data/models/movie_cover_model.dart';
import 'package:star_movie/src/domain/entities/movie_cover.dart';
import 'package:star_movie/src/domain/repositories/movie_repository.dart';

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
  Future<List<MovieCover>> getNowShowingMovies() async {
    return _getMovies(
      getLocalMovies: movieLocalDataSource.getNowShowingMovies,
      getRemoteMovies: movieRemoteDataSource.getNowShowingMovies,
      setMovies: movieLocalDataSource.setNowShowingMovies,
    );
  }

  @override
  Future<List<MovieCover>> getUpcomingMovies() async {
    return _getMovies(
      getLocalMovies: movieLocalDataSource.getUpcomingMovies,
      getRemoteMovies: movieRemoteDataSource.getUpcomingMovies,
      setMovies: movieLocalDataSource.setUpcomingMovies,
    );
  }

  Future<List<MovieCover>> _getMovies({
    required Future<List<MovieCoverModel>> Function() getLocalMovies,
    required Future<List<MovieCoverModel>> Function() getRemoteMovies,
    required Future<void> Function(List<MovieCoverModel>) setMovies,
  }) async {
    final now = DateTime.now();
    final cachedMovies = await getLocalMovies();
    final lastUpdate = await movieLocalDataSource.getLastUpdate();
    final shouldUpdate =
        lastUpdate == null || now.difference(lastUpdate).inDays >= 1;

    if (cachedMovies.isNotEmpty && !shouldUpdate) {
      return _mapToMovieCover(cachedMovies);
    }

    final remoteMovies = await getRemoteMovies();
    await setMovies(remoteMovies);
    await movieLocalDataSource.setLastUpdate(now);

    return _mapToMovieCover(remoteMovies);
  }

  Future<List<MovieCover>> _mapToMovieCover(
      List<MovieCoverModel> movieModels) async {
    var cachedGenres = await genreLocalDataSource.getGenres();

    if (cachedGenres.isEmpty) {
      cachedGenres = await _updateLocalGenres();
    }

    final genresMap = {for (var genre in cachedGenres) genre.id: genre};

    return Future.wait(movieModels.map((model) async {
      final genreNames = await _getGenreNamesByIds(model.genreIds, genresMap);
      return movieMapper.toMovieCover(model, genreNames);
    }));
  }

  Future<List<String>> _getGenreNamesByIds(
      List<int> genreIds, Map<int, GenreModel> genresMap) async {
    final genreNames = <String>[];
    final missingIds = <int>{};

    genreIds.forEach((id) {
      if (genresMap.containsKey(id)) {
        genreNames.add(genresMap[id]?.name ?? 'Unknown');
      } else {
        missingIds.add(id);
      }
    });

    if (missingIds.isNotEmpty) {
      final updatedGenres = await _updateLocalGenres();
      genresMap.addAll({for (var genre in updatedGenres) genre.id: genre});
    }

    missingIds.forEach((id) {
      genreNames.add(genresMap[id]?.name ?? 'Unknown');
    });

    return genreNames;
  }

  Future<List<GenreModel>> _updateLocalGenres() async {
    final genres = await genreRemoteDataSource.getGenres();
    await genreLocalDataSource.setGenres(genres);
    return genres;
  }
}
