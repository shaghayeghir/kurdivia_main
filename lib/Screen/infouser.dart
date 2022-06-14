import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
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

class InfoUser extends StatefulWidget {
  const InfoUser({Key? key}) : super(key: key);

  @override
  State<InfoUser> createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser> implements ApiStatusLogin {
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
                        image: AssetImage("assets/images/2.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 30,
                    top: 30,
                    child: InkWell(
                      onTap: () {},
                      child: const Image(
                        height: 40,
                        width: 40,
                        image: AssetImage('assets/images/setting.png'),
                      ),
                    ),
                  ),
                  FutureBuilder<DocumentSnapshot>(
                    future: value.getAllUserData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Something went wrong"),
                        );
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return const Center(
                          child: Text("Document does not exist"),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                        return Container(
                          child: Positioned(
                            bottom: 0,
                            child: SizedBox(
                              height: 650,
                              child: Stack(
                                children: [
                                  Align(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      width: MediaQuery.of(context).size.width,
                                      height: 570,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(30),
                                            topLeft: Radius.circular(30),
                                          )),
                                    ),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                  Container(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Stack(
                                          children: [
                                            CircleAvatar(
                                                radius: 50,
                                                backgroundColor: kDarkBlue,
                                                child: (data['image'] == '')
                                                    ? Text(
                                                  data['name']
                                                      .split('')
                                                      .first,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 40,
                                                      color: Colors.black),
                                                )
                                                    : Image.network(data['image'])),
                                            Positioned(
                                                bottom: 0,
                                                right: -10,
                                                child: IconButton(
                                                  icon:
                                                  Icon(Icons.add_a_photo_outlined,),
                                                  onPressed: () {
                                                    _pickImageFromGallery(context);
                                                  },
                                                ))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          data['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width *
                                              0.9,
                                          height: 50,
                                          child: TextField(
                                            controller: value.fullNameController,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              suffixIcon: Container(
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  height: 10,
                                                  width: 10,
                                                  child: const Image(
                                                      image: AssetImage(
                                                          'assets/images/user.png'),
                                                      fit: BoxFit.fill)),
                                              labelText: data['name'],
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(20),
                                                borderSide: const BorderSide(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width *
                                              0.9,
                                          height: 50,
                                          child: TextField(
                                            controller: value.phoneNumberController,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              suffixIcon: Container(
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  height: 10,
                                                  width: 10,
                                                  child: const Image(
                                                      image: AssetImage(
                                                          'assets/images/smartphone-call.png'),
                                                      fit: BoxFit.fill)),
                                              labelText: data['phonenumber'],
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(20),
                                                borderSide: const BorderSide(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 60,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            //context.read<ApiService>().signOut(context);
                                            value.occupationController.text =
                                            data['occupation'];
                                            value.locationController.text =
                                            data['location'];
                                            value.ageController.text = data['age'];
                                            if (value
                                                .fullNameController.text.isEmpty) {
                                              value.fullNameController.text =
                                              data['name'];
                                              value.signUpUser();
                                            } else if (value.phoneNumberController
                                                .text.isEmpty) {
                                              value.phoneNumberController.text =
                                              data['phonenumbers'];
                                              value.signUpUser();
                                            } else {
                                              value.signUpUser();
                                            }
                                          },
                                          child: Container(
                                            width: 200,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: kDarkBlue,
                                              borderRadius:
                                              BorderRadius.circular(30),
                                            ),
                                            child: const Center(
                                                child: Text(
                                                  'Save',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 17),
                                                )),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: const [
                                            DelayedDisplay(
                                              slidingCurve: Curves.bounceOut,
                                              slidingBeginOffset: Offset(0, 1),
                                              delay: Duration(milliseconds: 500),
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/facebook.png'),
                                                height: 20,
                                                width: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            DelayedDisplay(
                                              slidingCurve: Curves.bounceOut,
                                              slidingBeginOffset: Offset(0, 1),
                                              delay: Duration(milliseconds: 800),
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/instagram.png'),
                                                height: 20,
                                                width: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            DelayedDisplay(
                                              slidingCurve: Curves.bounceOut,
                                              slidingBeginOffset: Offset(0, 1),
                                              delay: Duration(milliseconds: 1100),
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/tik-tok.png'),
                                                height: 20,
                                                width: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            DelayedDisplay(
                                              slidingCurve: Curves.bounceOut,
                                              slidingBeginOffset: Offset(0, 1),
                                              delay: Duration(milliseconds: 1400),
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/telephone.png'),
                                                height: 20,
                                                width: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return const Center(
                        child: Text(
                          "loading...",
                          style: TextStyle(color: kDarkBlue, fontSize: 20),
                        ),
                      );
                    },
                  )
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
    kNavigator(context, const NavigateBar());
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
Future<void> _pickImageFromGallery(BuildContext context) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {

    context.read<ApiService>().updateProfileImage(pickedFile.path, );

  }
}
