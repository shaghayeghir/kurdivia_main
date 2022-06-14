
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:kurdivia/constant.dart';
class AgeCalculator extends StatefulWidget {
  @override
  _AgeCalculatorState createState() => _AgeCalculatorState();
}
class _AgeCalculatorState extends State<AgeCalculator> {

  DateTime? dateTime ;
  int age = 0;



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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Age Calculator"),
      ),
      body: InkWell(
        onTap: (){
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: const DatePickerTheme(
                  headerColor: kLightBlue,
                  backgroundColor: Colors.blue,
                  itemStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  doneStyle:
                  TextStyle(color: Colors.white, fontSize: 16)),
              onChanged: (date) {
                print('change $date in time zone ' +
                    date.timeZoneOffset.inHours.toString());
              }, onConfirm: (date) {
            dateTime = date;
            age = calculateAge(date);
                print('confirm $date');
                print(age);
              }, currentTime: DateTime.now(), locale: LocaleType.en);

        },
        child: Center(
          child: Container(
            child: Text('date'),
          ),
        ),
      ),
    );
  }
}