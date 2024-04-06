import 'package:flutter/material.dart';

import '../helpers/constants.dart';
import '../helpers/size_config.dart';

class BasicPageHeading extends StatelessWidget {
  const BasicPageHeading({required this.title, required this.subTitle});

  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        SizedBox(height: getProportionateScreenHeight(12)),
        Text(
          title,
          textAlign: TextAlign.center,
          style: kTitleTextStyle,
        ),
        Text(
          subTitle,
          textAlign: TextAlign.center,
          style: kTertiaryTextStyle,
        ),
      ],
    ));
  }
}
