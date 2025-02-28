import 'package:star_movie/src/data/models/base_model.dart';

class GenreModel extends BaseModel {
  GenreModel({required this.id, required this.name});

  final int id;
  final String name;

  @override
  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
