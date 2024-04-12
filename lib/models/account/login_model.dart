class LoginModel {
  String userId;
  String profileName;
  String email;
  String role;
  String accessToken;
  String refreshToken;
  String userName;
  String phoneNumber;
  final String message;

  LoginModel({
    required this.userId,
    required this.profileName,
    required this.email,
    required this.role,
    required this.accessToken,
    required this.refreshToken,
    required this.userName,
    required this.phoneNumber,
    required this.message,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json, String? message) {
    return LoginModel(
      userId: json['userId'] ?? '',
      profileName: json['profileName'] ?? '',
      email: json['email']?? '',
      role: json['role'] ?? '',
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      userName: json['userName'] ?? '',
      phoneNumber: json['MobileNo'] ?? '',
      message: message ?? '',
    );
  }

  factory LoginModel.fromNull(String nullString) {
    return LoginModel(userId: nullString,
        profileName: nullString,
        email: nullString,
        role: nullString,
        accessToken: nullString,
        refreshToken: nullString,
        userName: nullString,
        phoneNumber: nullString,
        message: nullString);
  }
}