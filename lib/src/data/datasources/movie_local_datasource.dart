import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_movie/src/data/constants/constants.dart';
import 'package:star_movie/src/data/models/movie_cover_model.dart';
import 'package:star_movie/src/domain/entities/enums/movie_cover_category.dart';

abstract class MovieLocalDataSource {
  Future<List<MovieCoverModel>> getMovieCovers(MovieCoverCategory category);

  Future<void> setMovieCovers(
      MovieCoverCategory category, List<MovieCoverModel> movies);

  Future<DateTime?> getLastUpdate();

  Future<void> setLastUpdate(DateTime dateTime);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  MovieLocalDataSourceImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<List<MovieCoverModel>> getMovieCovers(MovieCoverCategory category) {
    switch (category) {
      case MovieCoverCategory.nowShowing:
        return _getMovies(NOW_SHOWING_KEY);
      case MovieCoverCategory.upcoming:
        return _getMovies(UPCOMING_KEY);
    }
  }

  @override
  Future<void> setMovieCovers(
      MovieCoverCategory category, List<MovieCoverModel> movies) async {
    switch (category) {
      case MovieCoverCategory.nowShowing:
        _setMovies(NOW_SHOWING_KEY, movies);
      case MovieCoverCategory.upcoming:
        _setMovies(UPCOMING_KEY, movies);
    }
  }

  Future<List<MovieCoverModel>> _getMovies(String key) async {
    final jsonMovies = sharedPreferences.getStringList(key);
    if (jsonMovies == null || jsonMovies.isEmpty) {
      return [];
    }
    return jsonMovies
        .map((e) => MovieCoverModel.fromJson(json.decode(e)))
        .toList();
  }

  Future<void> _setMovies(String key, List<MovieCoverModel> movies) async {
    final jsonMovieModels = movies.map((e) => json.encode(e.toJson())).toList();
    await sharedPreferences.setStringList(key, jsonMovieModels);
  }

  @override
  Future<DateTime?> getLastUpdate() async {
    final lastUpdateString = sharedPreferences.getString(LAST_UPDATE_KEY);
    return lastUpdateString != null ? DateTime.parse(lastUpdateString) : null;
  }

  @override
  Future<void> setLastUpdate(DateTime dateTime) async {
    await sharedPreferences.setString(
        LAST_UPDATE_KEY, dateTime.toString());
  }
}
