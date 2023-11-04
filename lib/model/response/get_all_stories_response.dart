import 'dart:convert';
import 'package:story_app/model/story.dart';

class GetAllStoriesRepsonse {
  bool error;
  String message;
  List<Story> listStory;

  GetAllStoriesRepsonse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory GetAllStoriesRepsonse.fromRawJson(String str) =>
      GetAllStoriesRepsonse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllStoriesRepsonse.fromJson(Map<String, dynamic> json) =>
      GetAllStoriesRepsonse(
        error: json["error"],
        message: json["message"],
        listStory: List<Story>.from(
          json["listStory"].map(
            (x) => Story.fromJson(x),
          ),
        ),
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
