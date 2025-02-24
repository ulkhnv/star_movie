import 'package:star_movie/src/domain/entities/movie_cover.dart';
import 'package:star_movie/src/domain/repositories/movie_repository.dart';
import 'package:star_movie/src/domain/usecases/base_use_case.dart';
import 'package:star_movie/src/domain/usecases/movie_cover_params.dart';

class GetMovieCoversUseCase
    extends BaseUseCase<Future<List<MovieCover>>, MovieCoverParams> {
  GetMovieCoversUseCase({required this.movieRepository});

  final MovieRepository movieRepository;

  @override
  Future<List<MovieCover>> call(MovieCoverParams params) {
    return movieRepository.getMovieCovers(params);
  }
}
