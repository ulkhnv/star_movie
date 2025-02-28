abstract class BaseModel {
  const BaseModel();

  factory BaseModel.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson();
}
