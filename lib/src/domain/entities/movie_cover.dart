import 'package:equatable/equatable.dart';

class MovieCover extends Equatable {
  const MovieCover({
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.genreNames,
    required this.posterPath,
  });

  final int id;
  final String title;
  final double voteAverage;
  final List<String> genreNames;
  final String posterPath;

  @override
  List<Object?> get props => [
        id,
        title,
        voteAverage,
        genreNames,
        posterPath,
      ];
}
