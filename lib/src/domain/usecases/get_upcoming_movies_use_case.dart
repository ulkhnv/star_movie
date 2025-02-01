import 'package:star_movie/src/domain/entities/movie_cover.dart';
import 'package:star_movie/src/domain/repositories/movie_repository.dart';
import 'package:star_movie/src/domain/usecases/base_use_case.dart';

class GetUpcomingMoviesUseCase
    extends BaseUseCase<Future<List<MovieCover>>, void> {
  GetUpcomingMoviesUseCase({required this.movieRepository});

  final MovieRepository movieRepository;

  @override
  Future<List<MovieCover>> call(void params) {
    return movieRepository.getUpcomingMovies();
  }
}
