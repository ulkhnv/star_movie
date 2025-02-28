import 'package:star_movie/src/domain/entities/enums/movie_cover_category.dart';

class MovieCoverParams {
  const MovieCoverParams({
    required this.movieCoverCategory,
    this.forceUpdate = false,
    this.page = 1,
  });

  final MovieCoverCategory movieCoverCategory;
  final bool forceUpdate;
  final int page;
}
