import 'package:cc21_customer/helpers/preference_manager.dart';
import 'package:cc21_customer/models/customer_register_model.dart';
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
    }
    else if(phoneNoController.text.isNotEmpty){
      if(phoneNoController.text.length!=10){
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
                        Image(
                            image: AssetImage('assets/images/logo.png'),
                            height: getProportionateScreenHeight(50),
                            width: getProportionateScreenWidth(150)),
                        SizedBox(height: getProportionateScreenHeight(24)),
                        Text("Sign Up", style: kh2),
                        SizedBox(height: getProportionateScreenHeight(24)),
                        signUpForm(),
                        SizedBox(height: getProportionateScreenHeight(24)),
                        SizedBox(
                          width: getWidthForPercentage(100),
                          height: getProportionateScreenHeight(48),
                          child: ElevatedButton(
                              child: Text("Sign Up",
                                  style: kDefaultButtonTextStyle),
                              style: _signupEnabled
                                  ? kDefaultButtonStyleEnabled
                                  : kDefaultButtonStyleDisabled,
                              onPressed: () {
                                signUp();
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

  signUpForm() {
    return Center(
      child: Column(
        children: [
          TextField(
            controller: yourNameController,
            decoration: kOutlinedTextFieldStyle.copyWith(
                hintText: 'Enter your name', labelText: 'Your Name'),
          ),
          SizedBox(height: getProportionateScreenHeight(12)),
          TextField(
            controller: emailIdController,
            decoration: kOutlinedTextFieldStyle.copyWith(
                hintText: 'Enter your email id', labelText: 'Email Id'),
          ),
          SizedBox(height: getProportionateScreenHeight(12)),
          TextField(
            controller: passwordController,
            obscureText: !_passwordVisible,
            decoration: kOutlinedTextFieldStyle.copyWith(
              hintText: 'Enter your password',
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
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
          TextField(
            controller: confirmPasswordController,
            obscureText: !_confirmPasswordVisible,
            decoration: kOutlinedTextFieldStyle.copyWith(
              hintText: 'Enter your password again',
              labelText: 'Confirm Password',
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _confirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
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
          TextField(
            controller: phoneNoController,
            decoration: kOutlinedTextFieldStyle.copyWith(
                hintText: 'Enter phone number',
                labelText: 'Phone Number (optional)'),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: getProportionateScreenHeight(12)),
          TextField(
            controller: referalCodeController,
            decoration: kOutlinedTextFieldStyle.copyWith(
                hintText: 'Enter referal code',
                labelText: 'Referal Code (optional)'),
          ),
        ],
      ),
    );
  }
}
