import 'dart:convert';

BCategoryDd bCategoryDdFromJson(String str) => BCategoryDd.fromJson(json.decode(str));

String bCategoryDdToJson(BCategoryDd data) => json.encode(data.toJson());

class BCategoryDd {
  int businessCategoryId;
  String businessCategoryName;

  BCategoryDd({
    required this.businessCategoryId,
    required this.businessCategoryName,
  });

  factory BCategoryDd.fromJson(Map<String, dynamic> json) => BCategoryDd(
    businessCategoryId: json["BusinessCategoryID"],
    businessCategoryName: json["BusinessCategoryName"],
  );

  Map<String, dynamic> toJson() => {
    "BusinessCategoryID": businessCategoryId,
    "BusinessCategoryName": businessCategoryName,
  };
}