import 'dart:convert';

class DetailStory {
  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;

  DetailStory({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
  });

  factory DetailStory.fromRawJson(String str) =>
      DetailStory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DetailStory.fromJson(Map<String, dynamic> json) => DetailStory(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photoUrl": photoUrl,
        "createdAt": createdAt.toIso8601String(),
      };
}
