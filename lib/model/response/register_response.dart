import 'dart:convert';

class RegisterRepsonse {
  bool error;
  String message;

  RegisterRepsonse({
    required this.error,
    required this.message,
  });

  factory RegisterRepsonse.fromRawJson(String str) =>
      RegisterRepsonse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisterRepsonse.fromJson(Map<String, dynamic> json) =>
      RegisterRepsonse(
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
      };
}
