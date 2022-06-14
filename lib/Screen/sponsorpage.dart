import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kurdivia/Screen/questionpage.dart';
import 'package:kurdivia/constant.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';

import '../Widgets/navigatebar.dart';
import '../provider/ApiService.dart';

class SponsorPage extends StatefulWidget {
  SponsorPage({Key? key}) : super(key: key);
  late BuildContext context;


  @override
  State<SponsorPage> createState() => _SponsorPageState();
}

class _SponsorPageState extends State<SponsorPage> implements ApiStatusLogin {
  int Second = 0;

  Timer? timer;
  
  @override
  void initState() {
    Second = Provider.of<ApiService>(context, listen: false).maxsecond;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {setState(() {
      if(Second>0){
        Second--;
      }
      if(Second ==0){
        timer.cancel();
        // Provider.of<ApiService>(context,listen: false).getnumusersadd();
        kNavigator(context, QuestionPage());
      }
    });});
    super.initState();
  }
  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }
  @override
  void didChangeDependencies() {

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    context.read<ApiService>();
    this.widget.context = context;
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
                      image: AssetImage("assets/images/2.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20,top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: kDarkBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image(
                              image: AssetImage('assets/images/user.png'),
                              height: 20,
                              color: Colors.white,
                            ),
                            FutureBuilder<DocumentSnapshot>(
                              future: value.getnumusers(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot){
                                if(snapshot.hasData){
                                  return Text(snapshot.data!.get('numusers').toString());
                                }
                              return CircularProgressIndicator();
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 205,
                      ),
                      InkWell(
                        onTap: (){
                          kNavigatorBack(context);
                        },
                        child: Container(
                          child: const Image(
                            image: AssetImage('assets/images/cancel.png'),
                            height: 30,
                            width: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: context.read<ApiService>().getEventDetail(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot){
                      if(snapshot.hasData){
                        print('-----------------------------------------------');
                        print(snapshot.data!.docs[0]);
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.vertical(top: Radius.circular(30)),
                                  color: Colors.grey.shade300),
                              height: 600,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    height: 100,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: kLightBlue),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Align(
                                          child: Text(
                                            'Time Remaining :',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 15),
                                          ),
                                          alignment: Alignment.topCenter,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          child: Align(
                                            child: Text(
                                              Second.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 30),
                                            ),
                                            alignment: Alignment.topCenter,
                                          ),
                                          onTap: ()async{
                                            DateTime ntptime = await NTP.now();
                                            Timestamp ts = snapshot.data!.docs[0].get('date');
                                            print(ts.toDate());
                                            print(ntptime.difference(ts.toDate()));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 250,
                                      color: Colors.black,
                                      child: ClipRRect(
                                        child: Image(image: NetworkImage(snapshot.data!.docs[0].get('image'))),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(snapshot.data!.docs[0].get('title'),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    thickness: 2,
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(children: [
                                        Text('${snapshot.data!.docs[0].get('price')}'
                                        ),
                                        Image(image: AssetImage('assets/images/dollar.png'),height: 15,width: 15,)
                                      ]),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 30),
                                        child: const Image(image: AssetImage('assets/images/gift-box-with-a-bow.png'),height: 20,width: 20,),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('${snapshot.data!.docs[0].get('numwinner')}  >  number of winners'),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 30),
                                        child: const Image(image: AssetImage('assets/images/medal.png'),height: 20,width: 20,color: Colors.black,),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                          ),
                          Text(snapshot.error.toString()),
                        ],
                      );
                    },

                  ),

                ),
              ],
            ),
          ));
    }
    );
  }
  getnum(){
    Provider.of<ApiService>(context,listen: false).idevents;
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
