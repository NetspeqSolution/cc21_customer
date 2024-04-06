import 'package:cc21_customer/screens/account/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../helpers/constants.dart';
import '../../helpers/preference_manager.dart';
import '../../helpers/size_config.dart';
import '../../models/login_model.dart';
import '../../services/account_service.dart';
import '../home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AccountService accountService = new AccountService();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool _passwordVisible = false;
  bool showProgressBar = false;
  bool loginEnabled = false;

  @override
  void initState() {
    super.initState();
    usernameController.addListener(() {
      if (validateCredentials(showToast: false)) {
        setState(() {
          loginEnabled = true;
        });
      } else {
        setState(() {
          loginEnabled = false;
        });
      }
    });
    passwordController.addListener(() {
      if (validateCredentials(showToast: false)) {
        setState(() {
          loginEnabled = true;
        });
      } else {
        setState(() {
          loginEnabled = false;
        });
      }
    });
    setup();
  }

  setup() async {
    await PreferenceManager.init();
  }

  bool validateCredentials({bool showToast= false}) {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      if(showToast)
      Fluttertoast.showToast(msg: "Please enter email and/or password.");
      return false;
    }
    return true;
  }

  void LoginUser() async {
    if (validateCredentials(showToast: true) == false) return;

    setState(() {
      showProgressBar = true;
    });

    var response = await accountService.loginUser(
        usernameController.text, passwordController.text);

    if (response is String) {
      Fluttertoast.showToast(msg: response);
    } else {
      LoginModel loginDetails = response;
      await PreferenceManager.setAccessToken(loginDetails.accessToken);
      await PreferenceManager.setRefreshToken(loginDetails.refreshToken);
      await PreferenceManager.setProfileName(loginDetails.profileName);
      await PreferenceManager.setUserEmail(loginDetails.email);
      await PreferenceManager.setUserName(loginDetails.userName);
      await PreferenceManager.setUserID(loginDetails.userId);
      await PreferenceManager.setUserRole(loginDetails.role);
      if (loginDetails.role.toLowerCase().compareTo("customer") == 0) {
        Navigator.popAndPushNamed(context, HomeScreen.routeName);
      } else {
        Fluttertoast.showToast(msg: "This app is only for customers.");
      }
    }

    setState(() {
      showProgressBar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(12),
                horizontal: getProportionateScreenWidth(12)),
            child: showProgressBar
                ? Container(
                    child: Center(
                        child: CircularProgressIndicator(
                      color: kAccentColor,
                    )),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SvgPicture.asset('assets/images/cc21_logo.svg',
                            height: getProportionateScreenHeight(50),
                            width: getProportionateScreenWidth(150)),
                        SizedBox(height: getProportionateScreenHeight(24)),
                        Row(
                          children: [
                            Text("Get started with app", style: kh1),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Login or ", style: kh4),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, SignUpScreen.routeName);
                                },
                                child: Text("sign up",
                                    style: kh4.copyWith(color: kLinkColor))),
                            Text(" to use app", style: kh4),
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(24)),
                        Row(
                          children: [
                            Text("Email & Password", style: kh2),
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(12)),
                        TextField(
                          controller: usernameController,
                          decoration: kOutlinedTextFieldStyle.copyWith(
                              prefixIcon: Icon(
                                Icons.account_box_rounded,
                                color: kTextLight,
                              ),
                              hintText: 'Enter email',
                              labelText: 'Email'),
                        ),
                        SizedBox(height: getProportionateScreenHeight(12)),
                        TextField(
                          controller: passwordController,
                          obscureText: !_passwordVisible,
                          decoration: kOutlinedTextFieldStyle.copyWith(
                            hintText: 'Enter your password',
                            labelText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock,
                              color: kTextLight,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(12)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Forgot Password",
                              style: kh4.copyWith(color: kLinkColor),
                            )
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(12)),
                        SizedBox(
                          width: getWidthForPercentage(100),
                          height: getProportionateScreenHeight(48),
                          child: ElevatedButton(
                              child: Text("Continue",
                                  style: kDefaultButtonTextStyle),
                              style: loginEnabled
                                  ? kDefaultButtonStyleEnabled
                                  : kDefaultButtonStyleDisabled,
                              onPressed: () {
                                LoginUser();
                              }),
                        ),
                        SizedBox(height: getProportionateScreenHeight(24)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?", style: kh4),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, SignUpScreen.routeName);
                                },
                                child: Text(" Register here",
                                    style: kh4.copyWith(color: kLinkColor))),
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(24)),
                        Text("or login with", style: kh4),
                        SizedBox(height: getProportionateScreenHeight(24)),
                        SizedBox(
                          height: getProportionateScreenHeight(48),
                          width: getWidthForPercentage(100),
                          child: ElevatedButton(
                              child: Text("Phone & OTP",
                                  style: kDefaultButtonTextStyle),
                              style: kSecondaryButtonStyle,
                              onPressed: () {
                                LoginUser();
                              }),
                        ),
                        SizedBox(height: getProportionateScreenHeight(24)),
                        Text(
                          "By continuing you agree to our",
                          style: kh4,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Terms & Condition, Privacy Policy and Content Policy",
                          style: kh4.copyWith(fontFamily: "NotoSansBold"),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
