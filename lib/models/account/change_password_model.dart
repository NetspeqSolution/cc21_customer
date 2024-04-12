import 'dart:convert';

ChangePasswordModel changePasswordModelFromJson(String str) => ChangePasswordModel.fromJson(json.decode(str));

String changePasswordModelToJson(ChangePasswordModel data) => json.encode(data.toJson());

class ChangePasswordModel {
  String id;
  String userName;
  String oldPassword;
  String newPassword;

  ChangePasswordModel({
    required this.id,
    required this.userName,
    required this.oldPassword,
    required this.newPassword,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) => ChangePasswordModel(
    id: json["Id"],
    userName: json["UserName"],
    oldPassword: json["OldPassword"],
    newPassword: json["NewPassword"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "UserName": userName,
    "OldPassword": oldPassword,
    "NewPassword": newPassword,
  };
}
