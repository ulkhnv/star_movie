import 'package:star_movie/src/data/models/movie_cover_model.dart';
import 'package:star_movie/src/domain/entities/movie_cover.dart';

abstract class MovieMapper {
  MovieCover toMovieCover(MovieCoverModel movieModel, List<String> genres);
}

class MovieMapperImpl extends MovieMapper {
  @override
  MovieCover toMovieCover(MovieCoverModel movieModel, List<String> genres) {
    return MovieCover(
      id: movieModel.id,
      title: movieModel.title,
      voteAverage: movieModel.voteAverage,
      genreNames: genres,
      posterPath: movieModel.posterPath,
    );
  }
}
