import 'package:cc21_customer/screens/account/login_screen.dart';
import 'package:flutter/material.dart';

import '../../helpers/constants.dart';
import '../../helpers/size_config.dart';

class EmailVerificationScreen extends StatelessWidget {
  static String routeName = "/EmailVerificationScreen";
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(12),
                horizontal: getProportionateScreenWidth(12)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image(
                      image: AssetImage('assets/images/logo.png'),
                      height: getProportionateScreenHeight(50),
                      width: getProportionateScreenWidth(150)),
                  SizedBox(height: getProportionateScreenHeight(24)),
                  const Text("Email Veification",style: kTitleTextStyle),
                  SizedBox(height: getProportionateScreenHeight(12)),
                  const Text("A link has been sent to your email account, please confirm your email by clicking on the sent link.\n"
                      "You can come back and login after confirming your email.",style: kPrimaryTextStyle,textAlign: TextAlign.center,),
                  SizedBox(height: getProportionateScreenHeight(24)),
                  SizedBox(
                    width: getWidthForPercentage(100),
                    height: getProportionateScreenHeight(48),
                    child: ElevatedButton(
                        child: Text("Go to Login", style: kDefaultButtonTextStyle),
                        style: kDefaultButtonStyleEnabled,
                        onPressed: () {
                          Navigator.popUntil(context, ModalRoute.withName(LoginScreen.routeName));
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
