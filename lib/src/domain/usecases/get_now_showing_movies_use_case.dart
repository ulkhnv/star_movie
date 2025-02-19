import 'package:star_movie/src/domain/entities/movie_cover.dart';
import 'package:star_movie/src/domain/repositories/movie_repository.dart';
import 'package:star_movie/src/domain/usecases/base_use_case.dart';

class GetNowShowingMoviesUseCase
    extends BaseUseCase<Future<List<MovieCover>>, bool> {
  GetNowShowingMoviesUseCase({required this.movieRepository});

  final MovieRepository movieRepository;

  @override
  Future<List<MovieCover>> call(bool params) {
    return movieRepository.getNowShowingMovies(params);
  }
}
