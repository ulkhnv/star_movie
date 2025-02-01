import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_movie/src/data/constants/constants.dart';
import 'package:star_movie/src/data/models/genre_model.dart';

abstract class GenreLocalDataSource {
  Future<List<GenreModel>> getGenres();

  Future<void> setGenres(List<GenreModel> genreModels);
}

class GenreLocalDataSourceImpl extends GenreLocalDataSource {
  GenreLocalDataSourceImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<List<GenreModel>> getGenres() async {
    final jsonGenreModels = sharedPreferences.getStringList(genres);
    if (jsonGenreModels == null || jsonGenreModels.isEmpty) {
      return [];
    }
    return jsonGenreModels
        .map((e) => GenreModel.fromJson(json.decode(e)))
        .toList();
  }

  @override
  Future<void> setGenres(List<GenreModel> genreModels) async {
    final jsonGenreModels =
        genreModels.map((e) => json.encode(e.toJson())).toList();
    await sharedPreferences.setStringList(genres, jsonGenreModels);
  }
}
