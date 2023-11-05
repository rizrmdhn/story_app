import 'dart:convert';

import 'package:story_app/model/response/error_response.dart';

class LoginRepsonse {
  bool error;
  String message;
  LoginResult loginResult;

  LoginRepsonse({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  factory LoginRepsonse.fromRawJson(String str) =>
      LoginRepsonse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginRepsonse.fromJson(Map<String, dynamic> json) {
    if (json['error'] == true) {
      throw ErrorResponse.fromJson(json);
    } else {
      return LoginRepsonse(
        error: json["error"],
        message: json["message"],
        loginResult: LoginResult.fromJson(json["loginResult"]),
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "loginResult": loginResult.toJson(),
      };
}

class LoginResult {
  String userId;
  String name;
  String token;

  LoginResult({
    required this.userId,
    required this.name,
    required this.token,
  });

  factory LoginResult.fromRawJson(String str) =>
      LoginResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
        userId: json["userId"],
        name: json["name"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "token": token,
      };
}
