import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_movie/src/data/constants/constants.dart';
import 'package:star_movie/src/data/models/movie_cover_model.dart';

abstract class MovieLocalDataSource {
  Future<List<MovieCoverModel>> getNowShowingMovies();

  Future<void> setNowShowingMovies(List<MovieCoverModel> movieModels);

  Future<List<MovieCoverModel>> getUpcomingMovies();

  Future<void> setUpcomingMovies(List<MovieCoverModel> movieModels);

  Future<DateTime?> getLastUpdate();

  Future<void> setLastUpdate(DateTime dateTime);
}

class MovieLocalDataSourceImpl extends MovieLocalDataSource {
  MovieLocalDataSourceImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<List<MovieCoverModel>> getNowShowingMovies() async {
    return _getMovies(nowShowing);
  }

  @override
  Future<void> setNowShowingMovies(List<MovieCoverModel> movieModels) async {
    _saveMovies(nowShowing, movieModels);
  }

  @override
  Future<List<MovieCoverModel>> getUpcomingMovies() async {
    return _getMovies(upcoming);
  }

  @override
  Future<void> setUpcomingMovies(List<MovieCoverModel> movieModels) async {
    await _saveMovies(upcoming, movieModels);
  }

  Future<List<MovieCoverModel>> _getMovies(String key) async {
    final jsonMovieModels = sharedPreferences.getStringList(key);
    if (jsonMovieModels == null || jsonMovieModels.isEmpty) {
      return [];
    }
    return jsonMovieModels
        .map((e) => MovieCoverModel.fromJson(json.decode(e)))
        .toList();
  }

  Future<void> _saveMovies(
      String key, List<MovieCoverModel> movieModels) async {
    final jsonMovieModels =
        movieModels.map((e) => json.encode(e.toJson())).toList();
    await sharedPreferences.setStringList(key, jsonMovieModels);
  }

  @override
  Future<DateTime?> getLastUpdate() async {
    final lastUpdateString = sharedPreferences.getString(lastUpdate);
    return lastUpdateString != null ? DateTime.parse(lastUpdateString) : null;
  }

  @override
  Future<void> setLastUpdate(DateTime dateTime) async {
    await sharedPreferences.setString(lastUpdate, dateTime.toIso8601String());
  }
}
