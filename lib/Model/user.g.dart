// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  json['id'] as String,
  fullName:json['name'] as String,
  occupation: json['occupation'] as String,
  location: json['location'] as String,
  age: json['age'] as String,
  image: json['image'] as String,
  phoneNumber: json['phonenumber'] as String,



);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'occupation': instance.occupation,
  'location': instance.location,
  'age': instance.age,
  'image': instance.image,
  'phonenumber':instance.phoneNumber



};
