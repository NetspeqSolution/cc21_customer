import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
  String id;
  String email;
  String phoneNumber;
  String userImage;
  String profileName;

  UserProfileModel({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.userImage,
    required this.profileName,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
    id: json["Id"]??"",
    email: json["Email"]??"",
    phoneNumber: json["PhoneNumber"]??"",
    userImage: json["UserImage"]??"",
    profileName: json["ProfileName"]??"",
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Email": email,
    "PhoneNumber": phoneNumber,
    "UserImage": userImage,
    "ProfileName": profileName,
  };
}