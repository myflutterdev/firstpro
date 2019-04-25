import 'package:json_annotation/json_annotation.dart';

part 'Test.g.dart';

@JsonSerializable(nullable: true)
class Test {
  Test(this.id, this.uid, this.title, this.body);

  @JsonKey(name: 'userId')
  final String uid;
  final String id;
  final String title;
  final String body;

  factory Test.fromJson(Map<String, dynamic> json) => _$TestFromJson(json);

  Map<String, dynamic> toJson() => _$TestToJson(this);
}