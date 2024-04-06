import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;
  static late double pixelRatio;


  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    pixelRatio = _mediaQueryData.devicePixelRatio;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designers use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designers use
  return (inputWidth / 375.0) * screenWidth;
}

double getWidthForPercentage(double percentage) {
  if (percentage > 0 && percentage <= 100)
    return SizeConfig.screenWidth * (percentage / 100);
  else
    return SizeConfig.screenWidth;
}

double getHeightForPercentage(double percentage) {
  if (percentage > 0 && percentage <= 100)
    return SizeConfig.screenHeight * (percentage / 100.0);
  else
    return SizeConfig.screenHeight;
}

double getPixelRatio() {
  return SizeConfig.pixelRatio;
}