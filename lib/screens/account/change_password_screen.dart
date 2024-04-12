import 'package:cc21_customer/helpers/preference_manager.dart';
import 'package:cc21_customer/models/account/change_password_model.dart';
import 'package:cc21_customer/services/account_service.dart';
import 'package:flutter/material.dart';

import '../../helpers/constants.dart';
import '../../helpers/size_config.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  static String routeName = "/ChangePasswordScreen";

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool showProgressBar = false;
  TextEditingController passwordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  bool _passwordVisible = false,
      _newPasswordVisible = false,
      _confirmPasswordVisible = false;
  bool continueEnabled = false;
  AccountService accountService = new AccountService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passwordController.addListener(() {
      if (validateForm(showToast: false)) {
        setState(() {
          continueEnabled = true;
        });
      } else {
        setState(() {
          continueEnabled = false;
        });
      }
    });

    newPasswordController.addListener(() {
      if (validateForm(showToast: false)) {
        setState(() {
          continueEnabled = true;
        });
      } else {
        setState(() {
          continueEnabled = false;
        });
      }
    });

    confirmPasswordController.addListener(() {
      if (validateForm(showToast: false)) {
        setState(() {
          continueEnabled = true;
        });
      } else {
        setState(() {
          continueEnabled = false;
        });
      }
    });
  }

  bool validateForm({bool showToast = false}) {
    if (passwordController.text.isEmpty) {
      if (showToast) Fluttertoast.showToast(msg: "Enter old password.");
      return false;
    } else if (newPasswordController.text.isEmpty) {
      if (showToast) Fluttertoast.showToast(msg: "Enter new password.");
      return false;
    } else if (confirmPasswordController.text.isEmpty) {
      if (showToast) Fluttertoast.showToast(msg: "Confirm your password.");
      return false;
    } else if (newPasswordController.text
            .compareTo(confirmPasswordController.text) !=
        0) {
      if (showToast)
        Fluttertoast.showToast(msg: "New password does not match.");
      return false;
    }
    return true;
  }

  changePassword() async {
    if (validateForm(showToast: true)) {
      setState(() {
        showProgressBar = true;
      });

      ChangePasswordModel model = new ChangePasswordModel(id: PreferenceManager.getUserID(),
          userName: PreferenceManager.getUserName(),
          oldPassword: passwordController.text,
          newPassword: newPasswordController.text);

      var response = await accountService.changePassword(model);

      if (response is String && response.toLowerCase().contains("error")) {
        Fluttertoast.showToast(msg: response);
      } else {
        Fluttertoast.showToast(msg: "Password changed successfully.");
        await PreferenceManager.deleteUserBasicInfo();
        Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, ModalRoute.withName('/'));
      }

      setState(() {
        showProgressBar = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(12),
                    horizontal: getProportionateScreenWidth(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_sharp,
                        color: kWhite,
                      ),
                    ),
                    Center(
                      child: Text(
                        "Change Password",
                        style: kh2.copyWith(color: kWhite),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.home_filled,
                        color: kWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(12),
                  horizontal: getProportionateScreenWidth(12)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Old Password ",
                            style: kh3.copyWith(color: kBlack)),
                        Icon(
                          Icons.star_rate_rounded,
                          size: 14,
                          color: kRequiredIconColor,
                        )
                      ],
                    ),
                    TextField(
                      style: kh3,
                      controller: passwordController,
                      obscureText: !_passwordVisible,
                      decoration: kOutlinedTextFieldStyle.copyWith(
                        prefixIcon: Icon(
                          Icons.lock_open_sharp,
                          color: kTextBoxBorderColor,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                        Text("New Password ",
                            style: kh3.copyWith(color: kBlack)),
                        Icon(
                          Icons.star_rate_rounded,
                          size: 14,
                          color: kRequiredIconColor,
                        )
                      ],
                    ),
                    TextField(
                      style: kh3,
                      controller: newPasswordController,
                      obscureText: !_newPasswordVisible,
                      decoration: kOutlinedTextFieldStyle.copyWith(
                        prefixIcon: Icon(
                          Icons.lock_open_sharp,
                          color: kTextBoxBorderColor,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _newPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                            color: kButtonDisabledColor,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _newPasswordVisible = !_newPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(12)),
                    Row(
                      children: [
                        Text("Confrim New Password ",
                            style: kh3.copyWith(color: kBlack)),
                        Icon(
                          Icons.star_rate_rounded,
                          size: 14,
                          color: kRequiredIconColor,
                        )
                      ],
                    ),
                    TextField(
                      style: kh3,
                      controller: confirmPasswordController,
                      obscureText: !_confirmPasswordVisible,
                      decoration: kOutlinedTextFieldStyle.copyWith(
                        prefixIcon: Icon(
                          Icons.lock_open_sharp,
                          color: kTextBoxBorderColor,
                        ),
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
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(24)),
                    SizedBox(
                      width: getWidthForPercentage(100),
                      height: getProportionateScreenHeight(48),
                      child: ElevatedButton(
                          child:
                              Text("Continue", style: kDefaultButtonTextStyle),
                          style: continueEnabled
                              ? kDefaultButtonStyleEnabled
                              : kDefaultButtonStyleDisabled,
                          onPressed: () {
                            changePassword();
                          }),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
