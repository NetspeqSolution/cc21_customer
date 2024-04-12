import 'dart:convert';

UtblMstRestaurantOwnershipType utblMstRestaurantOwnershipTypeFromJson(String str) => UtblMstRestaurantOwnershipType.fromJson(json.decode(str));

String utblMstRestaurantOwnershipTypeToJson(UtblMstRestaurantOwnershipType data) => json.encode(data.toJson());

class UtblMstRestaurantOwnershipType {
  int ownershipTypeId;
  String ownershipTypeName;
  String userId;
  DateTime transDate;

  UtblMstRestaurantOwnershipType({
    required this.ownershipTypeId,
    required this.ownershipTypeName,
    required this.userId,
    required this.transDate,
  });

  factory UtblMstRestaurantOwnershipType.fromJson(Map<String, dynamic> json) => UtblMstRestaurantOwnershipType(
    ownershipTypeId: json["OwnershipTypeID"],
    ownershipTypeName: json["OwnershipTypeName"],
    userId: json["UserID"],
    transDate: DateTime.parse(json["TransDate"]),
  );

  Map<String, dynamic> toJson() => {
    "OwnershipTypeID": ownershipTypeId,
    "OwnershipTypeName": ownershipTypeName,
    "UserID": userId,
    "TransDate": transDate.toIso8601String(),
  };
}