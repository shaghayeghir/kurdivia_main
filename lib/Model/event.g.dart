// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventData _$EventDataFromJson(Map<String, dynamic> json) => EventData(

  title:json['title'] as String,
  description: json['description'] as String,
  date: json['date'] as Timestamp,
  link: json['link'] as String,
  numwinner: json['numwinner'] as String,
  price: json['price'] as String, opprice: json['opprice'] as String,
  numusers: json['numusers'] as int,




);

Map<String, dynamic> _$EventDataToJson(EventData instance) => <String, dynamic>{

  'title': instance.title,
  'description': instance.description,
  'date': instance.date,
  'link': instance.link,
  'numwinner' : instance.numwinner,
  'price' : instance.price,
  'opprice' : instance.opprice,
  'numusers' : instance.numusers,



};
