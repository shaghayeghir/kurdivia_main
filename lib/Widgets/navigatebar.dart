import 'package:flutter/material.dart';
import 'package:kurdivia/Screen/country.dart';
import 'package:kurdivia/Screen/infouser.dart';
import 'package:kurdivia/Screen/mainpage.dart';
import 'package:kurdivia/constant.dart';

class NavigateBar extends StatefulWidget {
  const NavigateBar({Key? key}) : super(key: key);

  @override
  State<NavigateBar> createState() => _NavigateBarState();
}

class _NavigateBarState extends State<NavigateBar> {
  int currentIndex = 0;
  final List<Widget> children = [
     MainPage(),
     InfoUser(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              child: children[currentIndex],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            currentIndex = 0;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 25,
                              height: 3,
                              color: currentIndex == 0
                                  ? Colors.blue
                                  : Colors.white,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Image(
                              image: AssetImage('assets/images/home.png'),
                              height: 25,
                              width: 25,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            currentIndex = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 25,
                              height: 3,
                              color: currentIndex == 1
                                  ? Colors.blue
                                  : Colors.white,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Image(
                              image: AssetImage('assets/images/user.png'),
                              height: 25,
                              width: 25,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // Stack(
        //   children: [
        //     children[currentIndex],
        //     Align(
        //       alignment: Alignment.bottomCenter,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
        //         ),
        //         child: SizedBox(
        //           height: 60,
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             children: [
        //               InkWell(
        //                 onTap: (){
        //                   setState(() {
        //                     currentIndex = 0;
        //                   });
        //                 },
        //                 child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: [
        //                     Container(
        //                       width: 25,
        //                       height: 3,
        //                       color: currentIndex==0 ?  Colors.blue : Colors.white,
        //                     ),
        //                     const SizedBox(
        //                       height: 10,
        //                     ),
        //                     const Image(image: AssetImage('assets/images/home.png'),height: 25,width: 25,
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //               InkWell(
        //                 onTap: (){
        //                   setState(() {
        //                     currentIndex = 1;
        //                   });
        //                 },
        //                 child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: [
        //                     Container(
        //                       width: 25,
        //                       height: 3,
        //                       color: currentIndex==1 ?  Colors.blue : Colors.white,
        //                     ),
        //                     const SizedBox(
        //                       height: 10,
        //                     ),
        //                     const Image(image: AssetImage('assets/images/user.png'),height: 25,width: 25,
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
