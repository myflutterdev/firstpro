// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      id: json['id'] as int,
      uid: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.uid,
      'id': instance.id,
      'title': instance.title,
      'body': instance.body
    };
