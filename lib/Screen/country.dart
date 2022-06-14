import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kurdivia/Screen/mainpage.dart';
import 'package:kurdivia/Widgets/navigatebar.dart';
import 'package:kurdivia/provider/ApiService.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../Widgets/navigatebar.dart';
import '../constant.dart';
import '../provider/ApiService.dart';
import 'country.dart';

class InfoLogin extends StatefulWidget {

  InfoLogin({required this.visible});
  bool visible = false;
  @override
  State<InfoLogin> createState() => _InfoLoginState();
}
class _InfoLoginState extends State<InfoLogin> implements ApiStatusLogin {
  late BuildContext context;
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  String phone = '';
  @override
  Widget build(BuildContext context) {
    context.read<ApiService>();
    this.context = context;
    return Consumer<ApiService>(
      builder: (context, value, child) {
        value.apiListener(this);
        return SafeArea(
            child: Scaffold(
          body: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/1.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.14),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  height: 630,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter your Fullname :',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 350,
                        height: 50,
                        child: TextField(
                          controller: value.fullNameController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            label: const Center(
                              child: Text('Full name'),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: widget.visible,
                        child: const Text(
                          'Enter your Phone Number :',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      Visibility(
                        visible: widget.visible,
                        child: const SizedBox(
                          height: 20,
                        ),
                      ),
                      Visibility(
                        visible: widget.visible,
                        child: SizedBox(
                          width: 350,
                          height: 70,
                          child: IntlPhoneField(
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(),
                              ),
                            ),
                            onChanged: (phone) {
                              value.phoneNumberController.text = phone.completeNumber;
                              print(value.phoneNumberController);
                            },
                            onCountryChanged: (country) {
                              print('Country changed to: ' + country.name);
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.visible,
                        child: const SizedBox(
                          height: 20,
                        ),
                      ),
                      const Text(
                        'Enter your occupation :',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 350,
                        height: 50,
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: value.occupationController,
                          decoration: InputDecoration(
                            label: const Center(
                              child: Text('Occupation'),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Enter your location :',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 350,
                        height: 50,
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: value.locationController,
                          decoration: InputDecoration(
                            label: const Center(
                              child: Text('Location'),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Age :',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            onTap: () {
                              value.selectdate(context);
                            },
                            child: SizedBox(
                              width: 80,
                              height: 50,
                              child: TextField(
                                enabled: false,
                                controller: value.ageController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  label: const Center(
                                    child: Text(
                                      'Age',
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: widget.visible ? 30 : 140,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            value.SaveUser(context);
                          },
                          child: Container(
                            width: 200,
                            height: 45,
                            decoration: BoxDecoration(
                              color: kDarkBlue,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                                child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
      },
    );
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

  @override
  void accountAvailable() {
    // TODO: implement accountAvailable
  }

  @override
  void error() {
    ModeSnackBar.show(context, 'something go wrong', SnackBarMode.error);
  }


}

