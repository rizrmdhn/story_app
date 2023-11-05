import 'dart:convert';

import 'package:story_app/model/response/error_response.dart';

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

  factory RegisterRepsonse.fromJson(Map<String, dynamic> json) {
    if (json['error'] == true) {
      throw ErrorResponse.fromJson(json).getErrorMessage();
    } else {
      return RegisterRepsonse(
        error: json["error"],
        message: json["message"],
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
      };
}
