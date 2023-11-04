import 'dart:convert';

class AddNewStoryRepsonseGuest {
  bool error;
  String message;

  AddNewStoryRepsonseGuest({
    required this.error,
    required this.message,
  });

  factory AddNewStoryRepsonseGuest.fromRawJson(String str) =>
      AddNewStoryRepsonseGuest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddNewStoryRepsonseGuest.fromJson(Map<String, dynamic> json) =>
      AddNewStoryRepsonseGuest(
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
      };
}
