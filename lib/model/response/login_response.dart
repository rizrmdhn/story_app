import 'dart:convert';

import 'package:story_app/model/response/error_response.dart';

class LoginResponse {
  bool error;
  String message;
  LoginResult loginResult;

  LoginResponse({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  factory LoginResponse.fromRawJson(String str) =>
      LoginResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json['error'] == true) {
        final errorResponse = ErrorResponse.fromJson(json);
        return LoginResponse(
          error: true,
          message: errorResponse.getErrorMessage(),
          loginResult: LoginResult(
            userId: '',
            name: '',
            token: '',
          ),
        );
      } else {
        return LoginResponse(
          error: json["error"],
          message: json["message"],
          loginResult: LoginResult.fromJson(json["loginResult"]),
        );
      }
    } catch (e) {
      return LoginResponse(
        error: true,
        message: 'Error parsing response',
        loginResult: LoginResult(
          userId: '',
          name: '',
          token: '',
        ), // Or handle this based on your use case
      );
    }
  }

  factory LoginResponse.failure(String message) => LoginResponse(
        error: true,
        message: message,
        loginResult: LoginResult(
          userId: '',
          name: '',
          token: '',
        ),
      );

  factory LoginResponse.success(LoginResult loginResult) => LoginResponse(
        error: false,
        message: '',
        loginResult: loginResult,
      );

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
