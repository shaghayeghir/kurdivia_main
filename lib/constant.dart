import 'package:flutter/material.dart';

const kDarkBlue = Color(0XFF6097B2);
const kLightBlue = Color(0XFF92dae6);

String kUser = 'Mohammad';

kNavigator(context, page) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => page),
  );
}
kNavigatorreplace(context, page) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => page),
  );
}

kNavigatorBack(context) {
  Navigator.of(context).pop();
}
