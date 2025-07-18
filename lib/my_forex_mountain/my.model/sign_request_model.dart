class SignupModel {
  final String username;
  final String firstName;
  final String lastName;
  final String customerMobile;
  final String customerEmail;
  final String sponsorUsername;
  final String password;
  final String confirmPassword;

  SignupModel({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.customerMobile,
    required this.customerEmail,
    required this.sponsorUsername,
    required this.password,
    required this.confirmPassword,
  });

  // Deserialize from JSON
  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      customerMobile: json['customer_mobile'] ?? '',
      customerEmail: json['customer_email'] ?? '',
      sponsorUsername: json['sponser_username'] ?? '',
      password: json['spassword'] ?? '',
      confirmPassword: json['confirm_password'] ?? '',
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'customer_mobile': customerMobile,
      'customer_email': customerEmail,
      'sponser_username': sponsorUsername,
      'spassword': password,
      'confirm_password': confirmPassword,
    };
  }
}


