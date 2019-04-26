import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable{
  User({this.id, this.uid, this.title, this.body}) : super([id, uid, title, body]);

  @JsonKey(name: 'userId')
  final int uid;
  final int id;
  final String title;
  final String body;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}