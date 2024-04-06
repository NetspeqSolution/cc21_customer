import 'dart:io';

import 'package:cc21_customer/helpers/constants.dart';
import 'package:cc21_customer/helpers/theme.dart';
import 'package:cc21_customer/screens/account/login_screen.dart';
import 'package:cc21_customer/screens/home_screen.dart';
import 'package:cc21_customer/services/helpers/network_helper.dart';
import 'package:cc21_customer/services/interceptor/dio_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'helpers/routes.dart';
import 'helpers/size_config.dart';
import 'package:get_it/get_it.dart';

SizeConfig sizeConfig = SizeConfig();
void main() {
  var dio = DioUtil().getInstance();
  final getIt = GetIt.instance;
  getIt.registerLazySingleton<NetworkHelper>(() => NetworkHelper(dio));
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: kPrimaryColor,
  ));
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return MaterialApp(
        theme: cc21CustomerTheme(),
        routes: routes,
        debugShowCheckedModeBanner: false,
        initialRoute: HomeScreen.routeName);
  }
}