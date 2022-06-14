import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kurdivia/Screen/country.dart';
import 'package:kurdivia/constant.dart';
import 'package:kurdivia/provider/ApiService.dart';
import 'package:provider/provider.dart';

class PhoneNumber extends StatelessWidget implements ApiStatusLogin {
  PhoneNumber({Key? key}) : super(key: key);
  late BuildContext context;
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  String phone = '';

  @override
  Widget build(BuildContext context) {
    context.read<ApiService>();
    this.context = context;
    return Consumer<ApiService>(builder: (context,value,child){
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
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    height: 350,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30))
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          child: Text('Enter your number :',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: 350,
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
                            },
                            onCountryChanged: (country) {
                              print('Country changed to: ' + country.name);
                            },
                          ),
                        ),
                        Visibility(
                          visible: (value.isWaitingForCode == false) ? false : true,
                          child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 70,vertical: 10),
                              child: Theme(
                                  data: ThemeData(
                                    primaryColor: Colors.redAccent,
                                    primaryColorDark: Colors.red,
                                  ),
                                  child: TextFormField(
                                    controller: value.codeController,
                                    cursorColor: Colors.purple.shade900,
                                    decoration: InputDecoration(
                                      label: const Center(
                                        child: Text("code"),
                                      ),

                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(),
                                      ),
                                    ),
                                  ))),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: ()async{
                              value.signUpWithPhoneNumber(context);

                              // kNavigator(context, InfoLogin());
                            },
                            child: Container(
                              width: 200,
                              height: 45,
                              decoration: BoxDecoration(
                                color: kDarkBlue,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Center(child: Text('Submit',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),
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
    });
  }

  @override
  void accountAvailable() {
    // TODO: implement accountAvailable
  }

  @override
  void error() {
    // TODO: implement error
  }

  @override
  void inputEmpty() {
    // TODO: implement inputEmpty
  }

  @override
  void inputWrong() {
    // TODO: implement inputWrong
  }

  @override
  void login() {
    // TODO: implement login
  }

  @override
  void passwordWeak() {
    // TODO: implement passwordWeak
  }
}
