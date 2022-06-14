import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kurdivia/Screen/sponsorpage.dart';
import 'package:provider/provider.dart';

import '../Widgets/navigatebar.dart';
import '../constant.dart';
import '../provider/ApiService.dart';
import 'country.dart';

class Setting extends StatelessWidget implements ApiStatusLogin {
  Setting({Key? key}) : super(key: key);
  late BuildContext context;
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  String phone = '';
  @override
  Widget build(BuildContext context) {
    context.read<ApiService>();
    this.context = context;
    return Scaffold(
        body: Consumer<ApiService>(builder: (context, value, child) {
          value.apiListener(this);
          return SafeArea(
              child: Scaffold(
                body: Container(

                ),
              ));
        }));
  }

  @override
  void accountAvailable() {}

  @override
  void error() {
    ModeSnackBar.show(context, 'something go wrong', SnackBarMode.error);
  }

  @override
  void inputEmpty() {
    ModeSnackBar.show(
        context, 'username or password empty', SnackBarMode.warning);
  }

  @override
  void inputWrong() {
    ModeSnackBar.show(
        context, 'username or password incorrect', SnackBarMode.warning);
  }

  @override
  void login() {
    kNavigator(context, NavigateBar());
  }

  @override
  void passwordWeak() {
    ModeSnackBar.show(context, 'password is weak', SnackBarMode.warning);
  }

}

