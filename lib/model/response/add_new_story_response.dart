import 'dart:convert';

class AddNewStoryRepsonse {
  bool error;
  String message;

  AddNewStoryRepsonse({
    required this.error,
    required this.message,
  });

  factory AddNewStoryRepsonse.fromRawJson(String str) =>
      AddNewStoryRepsonse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddNewStoryRepsonse.fromJson(Map<String, dynamic> json) =>
      AddNewStoryRepsonse(
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
      };
}
