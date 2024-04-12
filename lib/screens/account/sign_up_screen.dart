import 'package:cc21_customer/helpers/preference_manager.dart';
import 'package:cc21_customer/models/account/customer_register_model.dart';
import 'package:cc21_customer/screens/account/email_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:get_ip_address/get_ip_address.dart';

import '../../helpers/constants.dart';
import '../../helpers/size_config.dart';
import '../../services/account_service.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = "/SignUpScreen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showProgressBar = false;
  AccountService accountService = new AccountService();

  TextEditingController yourNameController = new TextEditingController();
  TextEditingController emailIdController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  TextEditingController phoneNoController = new TextEditingController();
  TextEditingController referalCodeController = new TextEditingController();
  bool _passwordVisible = false, _confirmPasswordVisible = false;
  bool _signupEnabled = false;

  void initState() {
    super.initState();
    yourNameController.addListener(() {
      if (validateSignUpForm(showToast: false)) {
        setState(() {
          _signupEnabled = true;
        });
      } else {
        setState(() {
          _signupEnabled = false;
        });
      }
    });
    emailIdController.addListener(() {
      if (validateSignUpForm(showToast: false)) {
        setState(() {
          _signupEnabled = true;
        });
      } else {
        setState(() {
          _signupEnabled = false;
        });
      }
    });
    passwordController.addListener(() {
      if (validateSignUpForm(showToast: false)) {
        setState(() {
          _signupEnabled = true;
        });
      } else {
        setState(() {
          _signupEnabled = false;
        });
      }
    });
    confirmPasswordController.addListener(() {
      if (validateSignUpForm(showToast: false)) {
        setState(() {
          _signupEnabled = true;
        });
      } else {
        setState(() {
          _signupEnabled = false;
        });
      }
    });
  }

  bool validateSignUpForm({bool showToast = false}) {
    if (yourNameController.text.isEmpty) {
      if (showToast) Fluttertoast.showToast(msg: "Please enter your name.");
      return false;
    } else if (emailIdController.text.isEmpty) {
      if (showToast) Fluttertoast.showToast(msg: "Please enter your email id.");
      return false;
    } else if (passwordController.text.isEmpty) {
      if (showToast) Fluttertoast.showToast(msg: "Please enter your password.");
      return false;
    } else if (confirmPasswordController.text.isEmpty) {
      if (showToast)
        Fluttertoast.showToast(msg: "Please confirm your password.");
      return false;
    } else if (confirmPasswordController.text
            .compareTo(passwordController.text) !=
        0) {
      if (showToast)
        Fluttertoast.showToast(msg: "Make sure both password fields match.");
      return false;
    } else if (phoneNoController.text.isNotEmpty) {
      if (phoneNoController.text.length != 10) {
        if (showToast) {
          Fluttertoast.showToast(msg: "Phone number needs to have 10 digit.");
          return false;
        }
      }
    }
    return true;
  }

  void signUp() async {
    if (validateSignUpForm(showToast: true) == false) return;

    try {
      setState(() {
        showProgressBar = true;
      });

      var ipAddress = IpAddress(type: RequestType.json);
      dynamic data = await ipAddress.getIpAddress();

      CustomerRegisterModel model = new CustomerRegisterModel(
        profileName: yourNameController.text,
        userName: yourNameController.text,
        email: emailIdController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
        referralCode: referalCodeController.text,
        userId: PreferenceManager.getUserID(),
        ipAddress: data.toString(),
        agreeTnc: true,
      );

      var response = await accountService.registerRestaurant(model);

      setState(() {
        showProgressBar = false;
      });

      if (response is String && response.toLowerCase().contains("error")) {
        Fluttertoast.showToast(msg: response);
      } else {
        Navigator.popAndPushNamed(context, EmailVerificationScreen.routeName);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: kGeneralError);
      setState(() {
        showProgressBar = false;
      });
    }
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
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: getProportionateScreenHeight(24)),
                        Row(
                          children: [
                            Text("Get started with app", style: kh1),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Create account to continue", style: kh4),
                          ],
                        ),
                        signUpForm(),
                        SizedBox(height: getProportionateScreenHeight(24)),
                        SizedBox(
                          width: getWidthForPercentage(100),
                          height: getProportionateScreenHeight(48),
                          child: ElevatedButton(
                              child: Text("Continue",
                                  style: kDefaultButtonTextStyle),
                              style: _signupEnabled
                                  ? kDefaultButtonStyleEnabled
                                  : kDefaultButtonStyleDisabled,
                              onPressed: () {
                                signUp();
                              }),
                        ),
                        SizedBox(height: getProportionateScreenHeight(24)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account? ", style: kh4),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Sign in",
                                    style: kh4.copyWith(color: kLinkColor))),
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(24)),
                        Text(
                          "By continuing you agree to our",
                          style: kh5,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Terms & Condition, Privacy Policy and Content Policy",
                          style: kh5.copyWith(fontFamily: "NotoSansBold"),
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

  signUpForm() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: getProportionateScreenHeight(24)),
          Row(
            children: [
              Text("Name ", style: kh3.copyWith(color: kBlack)),
              Icon(Icons.star_rate_rounded, size: 14,color: kRequiredIconColor,)
            ],
          ),
          TextField(
            style: kh3,
            controller: yourNameController,
            decoration: kOutlinedTextFieldStyle,
          ),
          SizedBox(height: getProportionateScreenHeight(12)),
          Row(
            children: [
              Text("Email ", style: kh3.copyWith(color: kBlack)),
              Icon(Icons.star_rate_rounded, size: 14,color: kRequiredIconColor,)
            ],
          ),
          TextField(
            style: kh3,
            controller: emailIdController,
            decoration: kOutlinedTextFieldStyle.copyWith(),
          ),
          SizedBox(height: getProportionateScreenHeight(12)),
          Row(
            children: [
              Text("Password ", style: kh3.copyWith(color: kBlack)),
              Icon(Icons.star_rate_rounded, size: 14,color: kRequiredIconColor,)
            ],
          ),
          TextField(
            style: kh3,
            controller: passwordController,
            obscureText: !_passwordVisible,
            decoration: kOutlinedTextFieldStyle.copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  size: 20,
                  color: kButtonDisabledColor,
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
            children: [
              Text("Confirm Password ", style: kh3.copyWith(color: kBlack)),
              Icon(Icons.star_rate_rounded, size: 14,color: kRequiredIconColor,)
            ],
          ),
          TextField(
            style: kh3,
            controller: confirmPasswordController,
            obscureText: !_confirmPasswordVisible,
            decoration: kOutlinedTextFieldStyle.copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _confirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  size: 20,
                  color: kButtonDisabledColor,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _confirmPasswordVisible = !_confirmPasswordVisible;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(12)),
          Row(
            children: [
              Text("Mobile No", style: kh3.copyWith(color: kBlack)),
            ],
          ),
          TextField(
            style: kh3,
            controller: phoneNoController,
            decoration: kOutlinedTextFieldStyle.copyWith(),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: getProportionateScreenHeight(12)),
          Row(
            children: [
              Text("Referral Code", style: kh3.copyWith(color: kBlack)),
            ],
          ),
          TextField(
            style: kh3,
            controller: referalCodeController,
            decoration: kOutlinedTextFieldStyle.copyWith(),
          ),
        ],
      ),
    );
  }
}
