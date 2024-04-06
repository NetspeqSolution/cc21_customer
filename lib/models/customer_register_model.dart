// To parse this JSON data, do
//
//     final customerRegisterModel = customerRegisterModelFromJson(jsonString);

import 'dart:convert';

CustomerRegisterModel customerRegisterModelFromJson(String str) => CustomerRegisterModel.fromJson(json.decode(str));

String customerRegisterModelToJson(CustomerRegisterModel data) => json.encode(data.toJson());

class CustomerRegisterModel {
  String profileName;
  String? userName;
  String email;
  String? phoneNo;
  String password;
  String confirmPassword;
  String? referralCode;
  bool agreeTnc;
  String? userId;
  String? ipAddress;

  CustomerRegisterModel({
    required this.profileName,
    this.userName,
    required this.email,
    this.phoneNo,
    required this.password,
    required this.confirmPassword,
    this.referralCode,
    required this.agreeTnc,
    this.userId,
    this.ipAddress,
  });

  factory CustomerRegisterModel.fromJson(Map<String, dynamic> json) => CustomerRegisterModel(
    profileName: json["ProfileName"],
    userName: json["UserName"]??"",
    email: json["Email"],
    phoneNo: json["PhoneNo"]??"",
    password: json["Password"],
    confirmPassword: json["ConfirmPassword"],
    referralCode: json["ReferralCode"]??"",
    agreeTnc: json["AgreeTNC"],
    userId: json["UserID"]??"",
    ipAddress: json["IPAddress"]??"",
  );

  Map<String, dynamic> toJson() => {
    "ProfileName": profileName,
    "UserName": userName,
    "Email": email,
    "PhoneNo": phoneNo,
    "Password": password,
    "ConfirmPassword": confirmPassword,
    "ReferralCode": referralCode,
    "AgreeTNC": agreeTnc,
    "UserID": userId,
    "IPAddress": ipAddress,
  };
}
