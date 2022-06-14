import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kurdivia/Screen/age.dart';
import 'package:kurdivia/Screen/sponsorpage.dart';
import 'package:kurdivia/constant.dart';
import 'package:kurdivia/provider/ApiService.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';

import '../Widgets/navigatebar.dart';
import '../Model/event.dart';
import '../Widgets/navigatebar.dart';

class MainPage extends StatelessWidget implements ApiStatusLogin {
  MainPage({Key? key}) : super(key: key);
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
                top: 30,
                left: 30,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: value.image == ''
                          ? Text(
                              value.name.split('').first,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  color: Colors.black),
                            )
                          : Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: Image(
                                    image: NetworkImage(value.image),
                                    fit: BoxFit.fill),
                              ),
                            ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      value.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 130,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: context.read<ApiService>().getAllEvents(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.73,
                                  child: ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      {
                                        return DelayedDisplay(
                                          delay: Duration(milliseconds: (600 * (index+1)).toInt()),
                                          fadeIn: true,
                                          slidingCurve: Curves.easeIn,
                                          child: InkWell(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 200,
                                              margin: const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    child: Image(
                                                      image: const AssetImage(
                                                          'assets/images/3.jpg'),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(30),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    children: [
                                                      DelayedDisplay(
                                                        child: Center(
                                                            child: getdata(snapshot
                                                                .data!
                                                                .docs[index]
                                                                .id)),
                                                        delay: Duration(milliseconds: (1000 * (index + 1)).toInt()),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onTap: () async {

                                            },
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                          //;
                        } else if (snapshot.hasError) {
                          return Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                              ),
                              Text(snapshot.error.toString()),
                            ],
                          );
                        }

                        return const CircularProgressIndicator();
                      },
                    )),
              ),
            ],
          ),
        ));
      },
    );
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

  getdata(x) {
    return Consumer<ApiService>(builder: (context, value, child) {
      return StreamBuilder<QuerySnapshot>(
        stream: context.read<ApiService>().getAllEventsData(x),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Timestamp ts = snapshot.data!.docs[0].get('date');
          // Provider.of<ApiService>(context,listen: false).checkenter(ts);
          if (snapshot.hasData) {
            return Container(
              height: 200,
              width: double.infinity,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(top: 5),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  EventData eventData = EventData.fromJson(
                      document.data()! as Map<String, dynamic>);
                  return Stack(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10, left: 100),
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            color: kLightBlue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              eventData.date
                                  .toDate()
                                  .toString()
                                  .substring(0, 16),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          )),
                      Positioned(
                        top: 40,
                        left: 0,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          height: 30,
                          width: 60,
                          decoration: const BoxDecoration(
                              color: kDarkBlue,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                eventData.numwinner,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Image(
                                image: AssetImage('assets/images/medal.png'),
                                height: 15,
                                width: 15,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 75,
                        left: 0,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          height: 30,
                          width: 40,
                          decoration: const BoxDecoration(
                              color: kDarkBlue,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30))),
                          child: Text(
                            eventData.opprice,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: value.visibily,
                        child: Positioned(
                          top: 100,
                          left: 130,
                          child: InkWell(
                            onTap: ()async{
                              DateTime ntptime = await NTP.now();
                              Timestamp ts = snapshot.data!.docs[0].get('date');
                              // value.maxsecond = ntptime.toUtc().difference(ts.toDate().toUtc()).inSeconds;
                              value.maxsecond = 2;
                              value.idevents = x;
                              // value.getnumusersadd();
                              kNavigator(context, SponsorPage());
                              print(value.idevents);
                              print(value.maxsecond);
                            },
                            child: Container(
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: kDarkBlue,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(child: Text('Enter')),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );

                  // InkWell(
                  //   onTap: ()async{
                  //     DateTime ntptime = await NTP.now();
                  //     print(ntptime);
                  //     Timestamp ts = eventData.date;
                  //     value.maxsecond = ntptime.difference(ts.toDate()).inSeconds;
                  //     print(value.maxsecond);
                  //   },
                  //   child: Text(eventData.title,));
                }).toList(),
              ),
            );
            //;
          } else if (snapshot.hasError) {
            return Column(
              children: [
                Text(snapshot.error.toString()),
              ],
            );
          }

          return CircularProgressIndicator();
        },
      );
    });
  }

}
