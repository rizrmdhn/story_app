import 'dart:convert';

import 'package:story_app/model/response/error_response.dart';

class RegisterResponse {
  bool error;
  String message;

  RegisterResponse({
    required this.error,
    required this.message,
  });

  factory RegisterResponse.fromRawJson(String str) =>
      RegisterResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    if (json['error'] == true) {
      throw ErrorResponse.fromJson(json).getErrorMessage();
    } else {
      return RegisterResponse(
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
