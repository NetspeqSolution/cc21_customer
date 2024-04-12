import 'package:cc21_customer/helpers/size_config.dart';
import 'package:flutter/material.dart';

const String kAppName = 'Geo Sikkim';
const String kFirstLaunch = 'First launch';
const String kUserEmail = 'User Email';
const String kUserName = 'User Name';
const String kUserId = 'User ID';
const String kAccessToken = 'Access Token';
const String kRefreshToken = 'Refresh Token';
const String kUserRole = 'User Role';
const String kUserCurrentRole = 'Currently selected Role';
const String kProfileName = 'Profile Name';
const String kUnreadNotification = 'Has Unread Notifications';
const String kUserImage = 'User Image';
const String kUSER_IMAGE = 'User Image';
const String kPHONE_NUMBER = 'User Phone Number';
const String kLOCATION = 'Currently selected location';
const String kLATITUDE = 'Current Latitude';
const String kLONGITUDE = 'Current longitude';
const String kDEVICE_ID = 'Firebase Device ID';
const String kId = 'Test ID';
const String kResId = 'Test ID';
const String kLat = 'lat';
const String kLng = 'lng';
const String kAddress = 'add';
//const String kUriScheme = 'http';
const String kUriScheme = 'https';
// const int kport = 7075;
const int kport = 8082;
// const String khost = '10.0.2.2';
const String khost = 'localhost';
const String kInternetError =
    'Error: Please check your internet, Try again later';
const String kGeneralError = 'Error: Something went wrong, Try again later';
const String kPlacesApiKey = 'AIzaSyBZbAIlLlcRXFqYg9JxT0VwJxLe_gjFaIE';
const String kWebLiveUploadURL = "https://cc21.netspeq.com/uploads/restaurantimages/";

const kAccentColor = Color(0xff4e45bf);
const kPrimaryColor = Color(0xff4e45bf);
const kSecondaryColor = Color(0xffEFEEFC);
const kTextDarkColor = Color(0xff232426);
const kTextGreyColor = Color(0xFF4E4F5B);
const kTextLight = Color(0xff67697C);
const kWhite = Color(0xffffffff);
const kBlack = Color(0xFF000000);
const kLinkColor = Color(0xFF1aa1fb);
const kButtonDisabledColor = Color(0xff676a7d);
const kButtonSecondaryColor = Color(0xfffab047);
const kTextBoxBorderColor = Color(0xfff2f2f4);
const kRequiredIconColor = Color(0xffbf1212);
const kTransparentBgColor = Color(0x42000000);


final kOutlinedTextFieldStyle = InputDecoration(
  contentPadding: EdgeInsets.symmetric(
    horizontal: getProportionateScreenWidth(8),
    vertical: getProportionateScreenHeight(8)
  ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(color: kTextBoxBorderColor)
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(color: kTextBoxBorderColor)
    ),
    hintStyle: kh3,
    labelStyle: kh3);

final kDefaultButtonStyleDisabled = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(kButtonDisabledColor),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),)));

final kDefaultButtonStyleEnabled = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(kPrimaryColor),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),)));

final kSecondaryButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(kButtonSecondaryColor),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),)));

const kDefaultButtonTextStyle =
    TextStyle(fontFamily: "NotoSansBold", fontSize: 16, color: kWhite);

const kPrimaryTextStyle =
    TextStyle(fontFamily: "NotoSans", fontSize: 16, color: kBlack);
const kSecondaryTextStyle =
    TextStyle(fontFamily: "NotoSans", fontSize: 16, color: kAccentColor);
const kTertiaryTextStyle =
    TextStyle(fontFamily: "PlaypenSans", fontSize: 16, color: kBlack);
const kTitleTextStyle =
    TextStyle(fontFamily: "PlaypenSans", fontSize: 22, color: kBlack);

const kh1 = TextStyle(fontFamily: "NotoSansBold", fontSize: 20, color: kBlack);
const kh2 = TextStyle(fontFamily: "NotoSansBold", fontSize: 18, color: kBlack);
const kh3 = TextStyle(fontFamily: "NotoSans", fontSize: 16, color: kTextLight);
const kh4 = TextStyle(fontFamily: "NotoSans", fontSize: 14, color: kTextLight);
const kh5 = TextStyle(fontFamily: "NotoSans", fontSize: 12, color: kTextLight);
const kh6 = TextStyle(fontFamily: "NotoSans", fontSize: 10, color: kTextLight);

// Row(
// mainAxisSize: MainAxisSize.min,
// children: [
// Icon(Icons.circle,size: 14,color:  partnerList
//     .elementAt(
// index)
//     .partner
//     .isActive?Colors.green:Colors.red,),
// Text(
// partnerList
//     .elementAt(
// index)
//     .partner
//     .isActive
// ? " open"
//     : " closed",
// style: kh4.copyWith(
// color: kWhite)),
// ],
// ),