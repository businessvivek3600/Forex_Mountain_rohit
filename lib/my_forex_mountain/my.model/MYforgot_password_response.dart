class ForgotPasswordResponse {
  final bool? status;
  final int? isLogin;
  final String? message;

  ForgotPasswordResponse({
    this.status,
    this.isLogin,
    this.message,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      status: json['status'] ,
      isLogin: json['is_login'] ,
      message: json['message'] ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'is_login': isLogin,
      'message': message,
    };
  }
}
