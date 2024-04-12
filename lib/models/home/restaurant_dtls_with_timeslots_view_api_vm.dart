// To parse this JSON data, do
//
//     final restaurantDtlsWithTimeSlotsViewApivm = restaurantDtlsWithTimeSlotsViewApivmFromJson(jsonString);

import 'dart:convert';

RestaurantDtlsWithTimeSlotsViewApivm restaurantDtlsWithTimeSlotsViewApivmFromJson(String str) => RestaurantDtlsWithTimeSlotsViewApivm.fromJson(json.decode(str));

String restaurantDtlsWithTimeSlotsViewApivmToJson(RestaurantDtlsWithTimeSlotsViewApivm data) => json.encode(data.toJson());

class RestaurantDtlsWithTimeSlotsViewApivm {
  List<PartnerList> partnerList;
  int totalRecords;

  RestaurantDtlsWithTimeSlotsViewApivm({
    required this.partnerList,
    required this.totalRecords,
  });

  factory RestaurantDtlsWithTimeSlotsViewApivm.fromJson(Map<String, dynamic> json) => RestaurantDtlsWithTimeSlotsViewApivm(
    partnerList: List<PartnerList>.from(json["PartnerList"].map((x) => PartnerList.fromJson(x))),
    totalRecords: json["TotalRecords"],
  );

  Map<String, dynamic> toJson() => {
    "PartnerList": List<dynamic>.from(partnerList.map((x) => x.toJson())),
    "TotalRecords": totalRecords,
  };
}

class PartnerList {
  Partner partner;
  List<RestaurantTimeSlot> restaurantTimeSlots;

  PartnerList({
    required this.partner,
    required this.restaurantTimeSlots,
  });

  factory PartnerList.fromJson(Map<String, dynamic> json) => PartnerList(
    partner: Partner.fromJson(json["Partner"]),
    restaurantTimeSlots: List<RestaurantTimeSlot>.from(json["RestaurantTimeSlots"].map((x) => RestaurantTimeSlot.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Partner": partner.toJson(),
    "RestaurantTimeSlots": List<dynamic>.from(restaurantTimeSlots.map((x) => x.toJson())),
  };
}

class Partner {
  String partnerId;
  String name;
  String mobileNo;
  String emailId;
  bool isActive;
  bool isApproved;
  bool isOperational;
  bool hasAboutCmsContent;
  bool isDisabledByAdmin;
  bool hasOperationalTiming;
  String imagesUpload;
  String coverImage;
  String address;
  String businessCategory;
  String operationType;
  String ownershipType;
  String primaryCuisine;
  String secondaryCuisine;
  String bizcategoryName;
  String todayIsClosed;
  double approxDist;
  String latitude;
  String longitude;
  String timeZone;
  bool servesLiquor;
  int deliveryZoneId;
  int areaPointId;
  int refrencePointId;
  bool addedRtt;

  Partner({
    required this.partnerId,
    required this.name,
    required this.mobileNo,
    required this.emailId,
    required this.isActive,
    required this.isApproved,
    required this.isOperational,
    required this.hasAboutCmsContent,
    required this.isDisabledByAdmin,
    required this.hasOperationalTiming,
    required this.imagesUpload,
    required this.coverImage,
    required this.address,
    required this.businessCategory,
    required this.operationType,
    required this.ownershipType,
    required this.primaryCuisine,
    required this.secondaryCuisine,
    required this.bizcategoryName,
    required this.todayIsClosed,
    required this.approxDist,
    required this.latitude,
    required this.longitude,
    required this.timeZone,
    required this.servesLiquor,
    required this.deliveryZoneId,
    required this.areaPointId,
    required this.refrencePointId,
    required this.addedRtt,
  });

  factory Partner.fromJson(Map<String, dynamic> json) => Partner(
    partnerId: json["PartnerID"]??"",
    name: json["Name"]??"",
    mobileNo: json["MobileNo"]??"",
    emailId: json["EmailID"]??"",
    isActive: json["IsActive"]??true,
    isApproved: json["IsApproved"]??true,
    isOperational: json["IsOperational"]??true,
    hasAboutCmsContent: json["HasAboutCMSContent"]??true,
    isDisabledByAdmin: json["IsDisabledByAdmin"]??false,
    hasOperationalTiming: json["HasOperationalTiming"]??true,
    imagesUpload: json["ImagesUpload"]??"",
    coverImage: json["CoverImage"]??"",
    address: json["Address"]??"",
    businessCategory: json["BusinessCategory"]??"",
    operationType: json["OperationType"]??"",
    ownershipType: json["OwnershipType"]??"",
    primaryCuisine: json["PrimaryCuisine"]??"",
    secondaryCuisine: json["SecondaryCuisine"]??"",
    bizcategoryName: json["BizcategoryName"]??"",
    todayIsClosed: json["TodayIsClosed"]??"",
    approxDist: json["ApproxDist"]?.toDouble(),
    latitude: json["Latitude"]??"",
    longitude: json["Longitude"]??"",
    timeZone: json["TimeZone"]??"",
    servesLiquor: json["ServesLiquor"]??true,
    deliveryZoneId: json["DeliveryZoneID"]??0,
    areaPointId: json["AreaPointID"]??0,
    refrencePointId: json["RefrencePointID"]??0,
    addedRtt: json["AddedRTT"]??true,
  );

  Map<String, dynamic> toJson() => {
    "PartnerID": partnerId,
    "Name": name,
    "MobileNo": mobileNo,
    "EmailID": emailId,
    "IsActive": isActive,
    "IsApproved": isApproved,
    "IsOperational": isOperational,
    "HasAboutCMSContent": hasAboutCmsContent,
    "IsDisabledByAdmin": isDisabledByAdmin,
    "HasOperationalTiming": hasOperationalTiming,
    "ImagesUpload": imagesUpload,
    "CoverImage": coverImage,
    "Address": address,
    "BusinessCategory": businessCategory,
    "OperationType": operationType,
    "OwnershipType": ownershipType,
    "PrimaryCuisine": primaryCuisine,
    "SecondaryCuisine": secondaryCuisine,
    "BizcategoryName": bizcategoryName,
    "TodayIsClosed": todayIsClosed,
    "ApproxDist": approxDist,
    "Latitude": latitude,
    "Longitude": longitude,
    "TimeZone": timeZone,
    "ServesLiquor": servesLiquor,
    "DeliveryZoneID": deliveryZoneId,
    "AreaPointID": areaPointId,
    "RefrencePointID": refrencePointId,
    "AddedRTT": addedRtt,
  };
}

class RestaurantTimeSlot {
  int dayNo;
  String dayName;
  String openingTime;
  String closingTime;

  RestaurantTimeSlot({
    required this.dayNo,
    required this.dayName,
    required this.openingTime,
    required this.closingTime,
  });

  factory RestaurantTimeSlot.fromJson(Map<String, dynamic> json) => RestaurantTimeSlot(
    dayNo: json["DayNo"]??"",
    dayName: json["DayName"]??"",
    openingTime: json["OpeningTime"]??"",
    closingTime: json["ClosingTime"]??"",
  );

  Map<String, dynamic> toJson() => {
    "DayNo": dayNo,
    "DayName": dayName,
    "OpeningTime": openingTime,
    "ClosingTime": closingTime,
  };
}
