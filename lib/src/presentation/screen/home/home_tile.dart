import 'package:star_movie/src/presentation/models/movie_cover_ui_model.dart';

class HomeTile {
  HomeTile({required this.nowShowingMovies, required this.upcomingMovies});

  final List<MovieCoverUIModel> nowShowingMovies;
  final List<MovieCoverUIModel> upcomingMovies;

  factory HomeTile.init() => HomeTile(
        nowShowingMovies: [],
        upcomingMovies: [],
      );

  HomeTile copyWith({
    List<MovieCoverUIModel>? nowShowingMovies,
    List<MovieCoverUIModel>? upcomingMovies,
  }) {
    return HomeTile(
      nowShowingMovies: nowShowingMovies ?? this.nowShowingMovies,
      upcomingMovies: upcomingMovies ?? this.upcomingMovies,
    );
  }
}
