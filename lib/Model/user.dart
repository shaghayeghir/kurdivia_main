import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserData {
  String id;
  String fullName='';
  String occupation = '';
  String location = '';
  String age = '';
  String? image='';
  String? phoneNumber='';




  UserData(this.id,{
    required this.fullName,
    required this.occupation,
    required this.location,
    required this.age,
    required this.phoneNumber,
    this.image,


  });

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
