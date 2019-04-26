import 'package:equatable/equatable.dart';

abstract class UserDataEvent extends Equatable {}

class FetchUser extends UserDataEvent {

  @override
  String toString() {
    return 'FetchUserEvent';
  }
  
}