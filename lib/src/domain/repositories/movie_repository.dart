import 'package:star_movie/src/domain/entities/movie_cover.dart';
import 'package:star_movie/src/domain/usecases/movie_cover_params.dart';

abstract class MovieRepository {
  Future<List<MovieCover>> getMovieCovers(MovieCoverParams params);
}
