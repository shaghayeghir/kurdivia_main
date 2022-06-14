import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kurdivia/Screen/login_1.dart';
import 'package:kurdivia/Widgets/navigatebar.dart';
import 'package:kurdivia/constant.dart';
import 'package:kurdivia/provider/ApiService.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ApiService(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool loggedIn = false;


  @override
  void initState() {
    // bool login = context.read<ApiService>().checkLogin();
    // Timer.periodic(const Duration(seconds: 3), (timer) {
    //   if (login) {
    //     Provider.of<ApiService>(context, listen: false).InfoUser();
    //     kNavigator(context, const NavigateBar());
    //   } else {
    //     kNavigator(context, FirstPage());
    //   }
    //   timer.cancel();
    // });
    bool login = context.read<ApiService>().checkLogin();
    if (login) {
      Provider.of<ApiService>(context, listen: false).InfoUser();
      loggedIn = true;
    } else {
      loggedIn = false;
    }
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => (loggedIn) ? const NavigateBar() : FirstPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kDarkBlue,
        body: Center(
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: const Text(
                'Quiz App',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
        ));
  }
}
