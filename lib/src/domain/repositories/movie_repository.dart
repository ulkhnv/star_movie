import 'package:star_movie/src/domain/entities/movie_cover.dart';

abstract class MovieRepository {
  Future<List<MovieCover>> getNowShowingMovies(bool forceUpdate);

  Future<List<MovieCover>> getUpcomingMovies(bool forceUpdate);
}
