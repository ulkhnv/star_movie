import 'package:equatable/equatable.dart';
import 'package:star_movie/src/presentation/constants/constants.dart';

class MovieCoverUIModel extends Equatable {
  const MovieCoverUIModel({
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

  double get voteAverageRounded => voteAverage.round() / 2;

  String get fullPosterPath => "$imagePath/$posterPath";
}
