import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class EventData {

  String title='';
  String description = '';
  Timestamp date ;
  String link = '';
  String numwinner;
  String price;
  String opprice;
  int numusers;



  EventData({
    required this.title,
    required this.description,
    required this.date,
    required this.link,
    required this.numwinner,
    required this.price,
    required this.opprice,
    required this.numusers,


  });

  factory EventData.fromJson(Map<String, dynamic> json) => _$EventDataFromJson(json);

  Map<String, dynamic> toJson() => _$EventDataToJson(this);
}
