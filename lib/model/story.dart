import 'dart:convert';

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

  factory Story.fromRawJson(String str) => Story.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      photoUrl: json["photoUrl"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photoUrl": photoUrl,
        "createdAt": createdAt.toIso8601String(),
      };
}
