class ErrorResponse {
  bool error;
  String message;

  ErrorResponse({
    required this.error,
    required this.message,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      error: json['error'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
        'error': error,
        'message': message,
      };

  String getErrorMessage() {
    return message;
  }

  // get error status
  bool getErrorStatus() {
    return error;
  }
}
