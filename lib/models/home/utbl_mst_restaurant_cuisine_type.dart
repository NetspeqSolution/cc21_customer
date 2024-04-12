
import 'dart:convert';

UtblMstRestaurantCuisineType utblMstRestaurantCuisineTypeFromJson(String str) => UtblMstRestaurantCuisineType.fromJson(json.decode(str));

String utblMstRestaurantCuisineTypeToJson(UtblMstRestaurantCuisineType data) => json.encode(data.toJson());

class UtblMstRestaurantCuisineType {
  int cuisineId;
  String cuisineName;
  String? userId;
  DateTime? transDate;

  UtblMstRestaurantCuisineType({
    required this.cuisineId,
    required this.cuisineName,
    this.userId,
    this.transDate,
  });

  factory UtblMstRestaurantCuisineType.fromJson(Map<String, dynamic> json) => UtblMstRestaurantCuisineType(
    cuisineId: json["CuisineID"],
    cuisineName: json["CuisineName"],
    userId: json["UserID"],
    transDate: DateTime.parse(json["TransDate"]),
  );

  Map<String, dynamic> toJson() => {
    "CuisineID": cuisineId,
    "CuisineName": cuisineName,
    "UserID": userId,
    "TransDate": transDate==null?DateTime.now():transDate!.toIso8601String(),
  };
}
