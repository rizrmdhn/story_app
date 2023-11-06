import 'dart:convert';
import 'package:story_app/model/response/error_response.dart';
import 'package:story_app/model/story.dart';

class GetAllStoriesResponse {
  bool error;
  String message;
  List<Story> listStory;

  GetAllStoriesResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory GetAllStoriesResponse.fromRawJson(String str) =>
      GetAllStoriesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllStoriesResponse.fromJson(Map<String, dynamic> json) {
    if (json['error'] == true) {
      throw ErrorResponse.fromJson(json).getErrorMessage();
    } else {
      return GetAllStoriesResponse(
        error: json["error"],
        message: json["message"],
        listStory: List<Story>.from(
          json["listStory"].map(
            (x) => Story.fromJson(x),
          ),
        ),
      );
    }
  }

  factory GetAllStoriesResponse.failure(String message) =>
      GetAllStoriesResponse(
        error: true,
        message: message,
        listStory: [],
      );

  factory GetAllStoriesResponse.success(List<Story> listStory) =>
      GetAllStoriesResponse(
        error: false,
        message: 'Success',
        listStory: listStory,
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "listStory": List<dynamic>.from(
          listStory.map(
            (x) => x.toJson(),
          ),
        ),
      };
}
