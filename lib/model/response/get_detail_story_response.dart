import 'dart:convert';
import 'package:story_app/model/detail_story.dart';

class GetDetailStoryRepsonse {
  bool error;
  String message;
  DetailStory story;

  GetDetailStoryRepsonse({
    required this.error,
    required this.message,
    required this.story,
  });

  factory GetDetailStoryRepsonse.fromRawJson(String str) =>
      GetDetailStoryRepsonse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetDetailStoryRepsonse.fromJson(Map<String, dynamic> json) =>
      GetDetailStoryRepsonse(
        error: json["error"],
        message: json["message"],
        story: DetailStory.fromJson(json["story"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "story": story.toJson(),
      };
}
