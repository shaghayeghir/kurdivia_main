import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:hive/hive.dart';

import 'package:intl/intl.dart';
import 'package:kurdivia/Model/user.dart';
import 'package:kurdivia/Screen/country.dart';
import 'package:kurdivia/Screen/mainpage.dart';
import 'package:kurdivia/Widgets/navigatebar.dart';
import 'package:kurdivia/constant.dart';
import 'package:ntp/ntp.dart';

import '../main.dart';

import 'package:http/http.dart' as http;

enum LoginStatus { error, login, isLogin, waiting, passwordWrong, emailWrong }
enum UploadData { error, upload, waiting }
enum UploadRecord { vaccine, visit, medicalExam }




class ApiService extends ChangeNotifier {
  FirebaseFirestore fs = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  //--------------------------------------------------------//
  TextEditingController fullname = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController occupation = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController agenumber = TextEditingController();

  //--------------------------------------------------------//
  TextEditingController get getfullname => fullname;

  TextEditingController get getphonenumber => phonenumber;

  TextEditingController get getoccupation => occupation;

  TextEditingController get getlocation => location;

  TextEditingController get getagenumber => agenumber;

  // [Data] --------------------------------------------//

  String name = 'M';
  String image = '';
  String Phonnumber = '';
  DateTime? dateTime;
  int age = 0;
  int maxsecond = 60;
  String idevents = '';
  int entertime = 0;
  bool visibily = true;
  int index = 1;

  // GET
  bool loadingAuth = false;
  bool isWaitingForCode = false;
  String myVerificationId = '-1';


  bool get isAuthLoading => loadingAuth;

  String get myUser => auth.currentUser!.uid;

  String? get myUserName => auth.currentUser!.email;
  late ApiStatusLogin apiStatus;
  late UploadStatus uploadStatus;

  ///////////////////phone_number///////////////////////////
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController get getPhoneNumberController => phoneNumberController;

/////////////////////verification_code//////////////////
  TextEditingController codeController = TextEditingController();

  TextEditingController get getCodeController => codeController;

  ////////////////sign_up_form///////////////////////
  TextEditingController fullNameController = TextEditingController();

  TextEditingController get getFullNameController => fullNameController;
  TextEditingController occupationController = TextEditingController();

  TextEditingController get getOccupationController => occupationController;
  TextEditingController locationController = TextEditingController();

  TextEditingController get getLocationController => locationController;
  TextEditingController ageController = TextEditingController();

  TextEditingController get getAgeController => ageController;

  final PageController _pageController = PageController();
  PageController get pageController => _pageController;




  clearInputRegisterVet() {
    // vetDirectionController.text = '';

    notifyListeners();
  }

  apiListener(ApiStatusLogin apiStatus) {
    this.apiStatus = apiStatus;
  }

  apiListenerUpload(UploadStatus uploadStatus) {
    this.uploadStatus = uploadStatus;
  }

  setLoading(bool b) {
    loadingAuth = b;
    notifyListeners();
  }

  initHive() async {
    if (!Hive.isBoxOpen('login')) {
      await Hive.openBox('login');
    }
  }

  bool checkLogin() {
    if (auth.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }
  ////////////////////get_data///////////////////
  Future<DocumentSnapshot<Map<String, dynamic>>> getAllUserData() {
    return fs.collection('users').doc(myUser).get();

  }
  // Future<DocumentSnapshot<Map<String, dynamic>>> getAllEventsData() {
  //   return fs.collection('events').doc().get();
  //
  // }



  Stream<QuerySnapshot> getAllEvents(){
    return fs.collection('events').snapshots();

  }
  Stream<QuerySnapshot> getAllEventsData(id){
    return fs.collection('events').doc(id).collection('data').snapshots();

  }
  Stream<QuerySnapshot> getEventDetail(){
    return fs.collection('events').doc(idevents).collection('data').snapshots();
  }
  Stream<QuerySnapshot> getallquestion(){
    return fs.collection('events').doc(idevents).collection('question').snapshots();
  }
  Future<DocumentSnapshot<Map<String, dynamic>>> getnumusers(){
    return fs.collection('events').doc(idevents).get();
  }

  getpageindex(int idx){
    index = idx + 1;
    notifyListeners();
  }
  getusers(){
    getnumusersremove();
  }

  getnumusersadd (){
    fs.collection('events').doc(idevents).get().then((value){
      int num = value.get('numusers');
      Map<String,dynamic> map = {};
      map['numusers'] = num+1;
      print(map);
      fs.collection('events').doc(idevents).update(map);
    });
  }
  getnumusersremove (){
    fs.collection('events').doc(idevents).get().then((value){
      int num = value.get('numusers');
      Map<String,dynamic> map = {};
      if(num > 0){
        map['numusers'] = num-1;
        print(map);
        fs.collection('events').doc(idevents).update(map);
      }

    });
  }


  checkenter(Timestamp ts)async{
    DateTime ntptime = await NTP.now();
    int entertime = ntptime.difference(ts.toDate()).inSeconds;
    if(entertime <= 300){
      visibily = true;
    }
    else if(entertime > 300){
      visibily = false;
    }
    notifyListeners();
  }

  updateProfileImage(String path ) async {
    String filename = '${auth.currentUser?.uid}.${path.substring(path.length-3)}';
    File file = File(path);
    TaskSnapshot snapshot = await storage.ref().child('$myUser/profilPic/$myUser/$filename').putFile(file);
    snapshot.ref.getDownloadURL().then((value){
      Map<String,dynamic> map = {};
      map['image'] = value;
      fs.collection('users').doc(myUser).update(map).whenComplete((){
        uploadStatus.uploaded();
        print('done');
      }).onError((error, stackTrace){
        uploadStatus.error();
      });
    });
  }


  signUpWithPhoneNumber(context) async {
    if (isWaitingForCode == false) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumberController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);

          print(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          } else {
            print(e);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          print(verificationId);

          isWaitingForCode = true;
          notifyListeners();

          myVerificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(verificationId);
        },
      );
    } else {
      if (myVerificationId != '-1') {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: myVerificationId, smsCode: codeController.text);
        UserCredential userCredential =
        await auth.signInWithCredential(credential);
        print(userCredential.user);
        print(auth.currentUser);
        // Map<String, dynamic> newMap = Map();
        // newMap['phone_number'] = auth.currentUser!.phoneNumber;
        // fs.collection('users').add(newMap).then((v) {
        //   notifyListeners();
        //   print(v);
        // });
        await fs.collection('users').doc(myUser).get().then((value){
          if(value.data() == null){
            kNavigator(context, InfoLogin(visible: false,));
          }
          else{
            name = value.get('name');
            image = value.get('image');
            kNavigator(context, const NavigateBar());
          }
        });

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential);
      }
    }
    isWaitingForCode = true;
    notifyListeners();
  }

  signUpUser() {
    String fullName = fullNameController.text;
    String occupation = occupationController.text;
    String location = locationController.text;
    String age = ageController.text;
    String? phone =(phoneNumberController.text.isEmpty)?auth.currentUser?.phoneNumber:phoneNumberController.text;
    UserData userData = UserData('',
        fullName: fullName,
        occupation: occupation,
        location: location,
        age: age, phoneNumber: phone);
    registerUser(userData);
  }
  Future registerUser(UserData user) async {
    if (auth.currentUser != null) {
      user.id = auth.currentUser!.uid;
      signUp(user);
    } else {
      apiStatus.error();
      setLoading(false);
    }
  }
  signUp(UserData user) async {
    user.id = myUser;
    fs.collection('users').doc(user.id).set(user.toJson()).then((value) {
      apiStatus.login();
      //clearInputRegister();
      setLoading(false);
    }).onError((error, stackTrace) {
      apiStatus.error();
      setLoading(false);
    });
  }

  InfoUser() async{
    await fs.collection('users').doc(myUser).get().then((value) {
      name = value.get('name');
      image = value.get('image');
      print(value.data());
    });
    notifyListeners();
  }


void LoginFacebook(context) async {
    try {
      final fbloginresult = await FacebookAuth.instance.login();
      final userdata = await FacebookAuth.instance.getUserData();
      final FacebookAuthCredential =
      FacebookAuthProvider.credential(fbloginresult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(FacebookAuthCredential);
      myUser;
      fullNameController.text = userdata['name'];
      image = userdata['picture']['data']['url'];
      print(myUser);
      await fs.collection('users').doc(myUser).get().then((value){
        if(value.data() == null){
          kNavigator(context, InfoLogin(visible: true,));
        }
        else{
          name = value.get('name');
          image = value.get('image');
          kNavigator(context, const NavigateBar());
        }
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  void SaveUser(context) async {
    try {
      if (fullNameController.text.isNotEmpty ||
          phoneNumberController.text.isNotEmpty ||
          occupationController.text.isNotEmpty ||
          locationController.text.isNotEmpty ||
          ageController.text.isNotEmpty) {
        fs.collection('users').doc(myUser).set({
          'name': fullNameController.text,
          'image': image,
          'phonenumber': phoneNumberController.text,
          'occupation': occupationController.text,
          'location': occupationController.text,
          'age': ageController.text,
          'birthday': DateTime(dateTime!.year, dateTime!.month, dateTime!.day),
        }).whenComplete(() {
          InfoUser();
          kNavigatorreplace(context, NavigateBar());
        });
      } else {
        //erroe
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void selectdate(context) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        theme: const DatePickerTheme(
            headerColor: kLightBlue,
            backgroundColor: Colors.blue,
            itemStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
        onChanged: (date) {
          print('change $date in time zone ' +
              date.timeZoneOffset.inHours.toString());
        },
        onConfirm: (date) {
          dateTime = date;
          age = calculateAge(date);
          ageController.text = age.toString();
          notifyListeners();

          print(ageController);
          print(age);
        },
        currentTime: DateTime.now(),
        locale: LocaleType.en);
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Future signOut(BuildContext context) async {
    await auth.signOut();
    fs.clearPersistence();

    // kNavigator(context,  MyHomePage());
  }
}

abstract class UploadStatus {
  void error();

  void uploading();

  void uploaded();
}

abstract class ApiStatusLogin {
  void error();

  void login();

  void inputWrong();

  void inputEmpty();

  void accountAvailable();

  void passwordWeak();
}

enum SnackBarMode {
  error,warning,success
}

class ModeSnackBar {

  static show(BuildContext context,String text , SnackBarMode snackBarMode){

    Color textColor = Colors.white;
    Color backGroundColor = Colors.green;

    switch(snackBarMode){
      case SnackBarMode.error:
        backGroundColor = Colors.redAccent;
        textColor = Colors.grey;
        break;
      case SnackBarMode.warning:
        backGroundColor = Colors.yellowAccent;
        textColor = Colors.grey;
        break;
      case SnackBarMode.success:
        backGroundColor = Colors.green;
        textColor = Colors.grey;
        break;
    }

    SnackBar snackBar = SnackBar(
      content: Text(text ,style: TextStyle(fontFamily: 'Mont'),),
      backgroundColor: backGroundColor,
      duration: const Duration(seconds: 2),
      elevation: 2,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}


