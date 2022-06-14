import 'dart:async';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:kurdivia/provider/ApiService.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../constant.dart';

class QuestionCard extends StatefulWidget {
  QuestionCard({
    required this.question,
    required this.a,
    required this.b,
    required this.c,
    required this.maxsecond,
    required this.image,
  });

  String question;
  String a;
  String b;
  String c;
  int maxsecond;
  String image;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  late BuildContext context;
  @override
  int Second = 0;
  double percent = 0;
  double value = 0;
  Timer? timer;
  bool selected = false;



  @override
  void initState() {
    Second = widget.maxsecond;
    percent = 100 / Second;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (Second > 0) {
          Second--;
          value += percent;
        }
        if (Second == 0) {
          timer.cancel();
          Provider.of<ApiService>(context, listen: false)
              .pageController
              .nextPage(duration: Duration(seconds: 1), curve: Curves.ease);
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<ApiService>();
    this.context = context;
    return Consumer<ApiService>(builder: (context, value, child) {
      return Stack(
        children: [
          Positioned(
            top: 130,
            left: 20,
            child: Container(
              padding: EdgeInsets.only(left: 20,right: 20,bottom: 35,top: 15),
              height: 250,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.question),
                      widget.image != ''
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                              child: Image(
                              image: NetworkImage(widget.image),
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ))
                          : Container(),
                    ]),
              ),
            ),
          ),
          Positioned(
            top: 390,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 335,
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 500),
                    slidingCurve: Curves.elasticInOut,
                    child: InkWell(
                      onTap: () {
                        selected = true;
                        value.notifyListeners();
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color:  kLightBlue,
                        ),
                        child: Text('A : ${widget.a}'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 800),
                    slidingCurve: Curves.elasticInOut,
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: kLightBlue,
                      ),
                      child: Text('B : ${widget.b}'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 1100),
                    slidingCurve: Curves.elasticInOut,
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: kLightBlue,
                      ),
                      child: Text('C : ${widget.c}'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 350,
            left: 170,
            child: CircleAvatar(
              backgroundColor: kDarkBlue,
              radius: 35,
              child:Stack(
                children: [
                  getFilledProgressStyle(),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      Second.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ),
                ],
              )


            ),
          ),
        ],
      );
    });
  }

  Widget getFilledProgressStyle() {
    return Container(
        height: 120,
        width: 120,
        child: SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 100,
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.95,
            axisLineStyle: AxisLineStyle(
              thickness: 0.14,
              color: kLightBlue,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: value ,
                width: 0.95,
                pointerOffset: 0.05,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationType: AnimationType.ease,
                animationDuration: 500,
              )
            ],
          )
        ]));
  }
}
