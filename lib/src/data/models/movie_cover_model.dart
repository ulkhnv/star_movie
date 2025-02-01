class MovieCoverModel {
  const MovieCoverModel({
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.genreIds,
    required this.posterPath,
  });

  final int id;
  final String title;
  final double voteAverage;
  final List<int> genreIds;
  final String posterPath;

  factory MovieCoverModel.fromJson(Map<String, dynamic> json) {
    return MovieCoverModel(
      id: json['id'] as int,
      title: json['title'] as String,
      voteAverage: (json['vote_average'] as num).toDouble(),
      genreIds: List<int>.from(json['genre_ids']),
      posterPath: json['poster_path'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'vote_average': voteAverage,
      'genre_ids': genreIds,
      'poster_path': posterPath,
    };
  }
}
