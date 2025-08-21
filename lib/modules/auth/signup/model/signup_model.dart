class SignupResponse {
  final bool status;
  final String message;
  final int? userId;

  SignupResponse({
    required this.status,
    required this.message,
    this.userId,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      userId: json['user_id'],
    );
  }
}
