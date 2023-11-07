import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable()
class Story {
  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;

  Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
  });

  factory Story.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
