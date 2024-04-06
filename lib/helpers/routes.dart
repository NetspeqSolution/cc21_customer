import 'package:cc21_customer/screens/account/email_verification_screen.dart';
import 'package:cc21_customer/screens/account/login_screen.dart';
import 'package:cc21_customer/screens/account/sign_up_screen.dart';
import 'package:cc21_customer/screens/cart/cart_screen.dart';
import 'package:cc21_customer/screens/notification/notification_screen.dart';
import 'package:cc21_customer/screens/orders/order_screen.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => HomeScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  EmailVerificationScreen.routeName: (context) => EmailVerificationScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  NotificationScreen.routeName: (context) => NotificationScreen(),
  OrderScreen.routeName: (context) => OrderScreen(),
};
