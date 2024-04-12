import 'dart:convert';

UtblMstRestaurantOperationType utblMstRestaurantOperationTypeFromJson(String str) => UtblMstRestaurantOperationType.fromJson(json.decode(str));

String utblMstRestaurantOperationTypeToJson(UtblMstRestaurantOperationType data) => json.encode(data.toJson());

class UtblMstRestaurantOperationType {
  int operationTypeId;
  String operationTypeName;
  String? userId;
  DateTime? transDate;

  UtblMstRestaurantOperationType({
    required this.operationTypeId,
    required this.operationTypeName,
    this.userId,
    this.transDate,
  });

  factory UtblMstRestaurantOperationType.fromJson(Map<String, dynamic> json) => UtblMstRestaurantOperationType(
    operationTypeId: json["OperationTypeID"],
    operationTypeName: json["OperationTypeName"],
    userId: json["UserID"],
    transDate: DateTime.parse(json["TransDate"]),
  );

  Map<String, dynamic> toJson() => {
    "OperationTypeID": operationTypeId,
    "OperationTypeName": operationTypeName,
    "UserID": userId,
    "TransDate": transDate==null?DateTime.now():transDate!.toIso8601String(),
  };
}
