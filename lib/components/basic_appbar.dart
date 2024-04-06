import 'package:flutter/material.dart';

import '../helpers/constants.dart';
import '../helpers/size_config.dart';
import '../screens/home_screen.dart';

class BasicAppBar extends StatelessWidget {
  const BasicAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(12),
              horizontal: getProportionateScreenWidth(12)),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_sharp, color: kBlack)),
                ),
              ),
              Expanded(
                  flex: 5,
                  child: Image(
                      image: AssetImage('assets/images/logo.png'),
                      height: getProportionateScreenHeight(20),
                      width: getProportionateScreenWidth(60))),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
                      },
                      child: Icon(Icons.home_outlined, color: kBlack)),
                ),
              ),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(
                vertical: 0, horizontal: getProportionateScreenWidth(12)),
            child: Divider(
                color: kTextLight, height: getProportionateScreenHeight(1))),
      ],
    );
  }
}
