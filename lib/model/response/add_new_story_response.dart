import 'dart:convert';
import 'package:story_app/model/response/error_response.dart';

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

  factory AddNewStoryRepsonse.fromJson(Map<String, dynamic> json) {
    if (json['error'] == true) {
      throw ErrorResponse.fromJson(json);
    } else {
      return AddNewStoryRepsonse(
        error: json["error"],
        message: json["message"],
      );
    }
  }

  factory AddNewStoryRepsonse.failure(String message) => AddNewStoryRepsonse(
        error: true,
        message: message,
      );

  factory AddNewStoryRepsonse.success() => AddNewStoryRepsonse(
        error: false,
        message: 'Success',
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
      };
}
