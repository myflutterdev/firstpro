// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Test _$TestFromJson(Map<String, dynamic> json) {
  return Test(json['id'] as String, json['userId'] as String,
      json['title'] as String, json['body'] as String);
}

Map<String, dynamic> _$TestToJson(Test instance) => <String, dynamic>{
      'userId': instance.uid,
      'id': instance.id,
      'title': instance.title,
      'body': instance.body
    };
