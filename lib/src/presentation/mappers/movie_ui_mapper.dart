import 'package:star_movie/src/domain/entities/movie_cover.dart';
import 'package:star_movie/src/presentation/models/movie_cover_ui_model.dart';

abstract class MovieUiMapper {
  MovieCoverUIModel toMovieCoverUIModel(MovieCover movieCover);
}

class MovieUIMapperImpl extends MovieUiMapper {
  @override
  MovieCoverUIModel toMovieCoverUIModel(MovieCover movieCover) {
    return MovieCoverUIModel(
      id: movieCover.id,
      title: movieCover.title,
      voteAverage: movieCover.voteAverage,
      genreNames: movieCover.genreNames,
      posterPath: movieCover.posterPath,
    );
  }
}
