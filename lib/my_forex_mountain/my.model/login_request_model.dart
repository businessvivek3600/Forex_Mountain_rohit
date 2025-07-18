class LoginRequestModel {
  String username;
  String password;
  String? device_id;
  String? device_name;

  LoginRequestModel({
    required this.username,
    required this.password,
    this.device_id,
    this.device_name,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      device_id: json['device_id'],
      device_name: json['device_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'device_id': device_id,
      'device_name': device_name,
    };
  }
}
