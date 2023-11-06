class LogoutResponse {
  bool? error;
  String? message;

  LogoutResponse({this.message, this.error});

  factory LogoutResponse.failure(String message) => LogoutResponse(
        error: true,
        message: message,
      );

  factory LogoutResponse.success() => LogoutResponse(
        error: false,
        message: 'Success',
      );
}
