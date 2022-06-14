import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kurdivia/Screen/questioncard.dart';
import 'package:kurdivia/provider/ApiService.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage({Key? key}) : super(key: key);

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}


class _QuestionPageState extends State<QuestionPage> {
  late BuildContext context;

  @override
  void dispose() {

    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    context.read<ApiService>();
    this.context = context;
    return Consumer<ApiService>(builder: (context,value,child){
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
                top: 20,
                child: Row(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Image(
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
                      width: 55,
                    ),
                    const Text(
                      'Sponsor',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 100,
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     kNavigatorBack(context);
                    //   },
                    //   child: Container(
                    //     margin: EdgeInsets.symmetric(horizontal: 20),
                    //     child: const Image(
                    //       image: AssetImage('assets/images/cancel.png'),
                    //       height: 30,
                    //       width: 30,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Positioned(
                left: 20,
                top: 75,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          child: Image(
                            image: AssetImage('assets/images/speaker.png'),
                            height: 30,
                            width: 30,
                          ),
                        ),
                        const SizedBox(
                          width: 120,
                        ),
                        CircleAvatar(
                          child: Text(value.index.toString()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        StreamBuilder<QuerySnapshot>(
            stream: context.read<ApiService>().getallquestion(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasData){
                return PageView.builder(
                  onPageChanged: value.getpageindex,
                    physics: NeverScrollableScrollPhysics(),
                    controller: value.pageController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context,index){
                      return QuestionCard(
                        question: snapshot.data!.docs[index].get('question'),
                        a: snapshot.data!.docs[index].get('a'),
                        b: snapshot.data!.docs[index].get('b'),
                        c: snapshot.data!.docs[index].get('c'),
                        maxsecond: snapshot.data!.docs[index].get('time'),
                        image: snapshot.data!.docs[index].get('image'),
                      );

                      //   Stack(
                      //   children: [
                      //     Positioned(
                      //       top: 130,
                      //       left: 20,
                      //       child: Container(
                      //         height: 250,
                      //         width: MediaQuery.of(context).size.width * 0.9,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(30),
                      //           color: Colors.white,
                      //         ),
                      //         child: Center(
                      //           child: Text(snapshot.data!.docs[index].get('question')),
                      //         ),
                      //       ),
                      //     ),
                      //     Positioned(
                      //       top: 390,
                      //       left: 20,
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //             color: Colors.white,
                      //             borderRadius: BorderRadius.circular(30)),
                      //         width: MediaQuery.of(context).size.width * 0.9,
                      //         height: 335,
                      //         child: Column(
                      //           children: [
                      //             const SizedBox(
                      //               height: 50,
                      //             ),
                      //             InkWell(
                      //               onTap: (){
                      //                 value.pageController.nextPage(duration: Duration(seconds: 2), curve: Curves.ease);
                      //               },
                      //               child: Container(
                      //                 alignment: Alignment.centerLeft,
                      //                 height: 80,
                      //                 width: MediaQuery.of(context).size.width,
                      //                 padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      //                 margin: const EdgeInsets.symmetric(horizontal: 20),
                      //                 decoration: BoxDecoration(
                      //                   borderRadius: BorderRadius.circular(25),
                      //                   color: kLightBlue,
                      //                 ),
                      //                 child: Text('A : ${snapshot.data!.docs[index].get('a')}'),
                      //               ),
                      //             ),  const SizedBox(
                      //               height: 10,
                      //             ),
                      //             Container(
                      //               height: 80,
                      //               width: MediaQuery.of(context).size.width,
                      //               alignment: Alignment.centerLeft,
                      //               padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      //               margin: const EdgeInsets.symmetric(horizontal: 20),
                      //               decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(25),
                      //                 color: kLightBlue,
                      //               ),
                      //               child: Text('B : ${snapshot.data!.docs[index].get('b')}'),
                      //             ),  const SizedBox(
                      //               height: 10,
                      //             ),
                      //             Container(
                      //               height: 80,
                      //               width: MediaQuery.of(context).size.width,
                      //               alignment: Alignment.centerLeft,
                      //               margin: const EdgeInsets.symmetric(horizontal: 20),
                      //               padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      //               decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(25),
                      //                 color: kLightBlue,
                      //               ),
                      //               child: Text('C : ${snapshot.data!.docs[index].get('c')}'),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     const Positioned(
                      //       top: 350,
                      //       left: 170,
                      //       child: CircleAvatar(
                      //         radius: 35,
                      //         child: Text(
                      //           '8',
                      //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // );
                    });
              }
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                  Text(snapshot.error.toString()),
                ],
              );
            }),
            ],
          ),
        ),
      );



    });
  }
}
