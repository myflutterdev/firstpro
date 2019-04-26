import 'package:equatable/equatable.dart';
import 'package:myapp/user.dart';

abstract class UserDataState extends Equatable {
  UserDataState([List props = const []]) : super(props);
}

class UserDataUnInit extends UserDataState {
  @override
  String toString() {
    return 'UserData NotInitalize';
  }
}

class UserDataError extends UserDataState {
  @override
  String toString() {
    return 'UserData Error';
  }
}

class UserDataLoaded extends UserDataState {
  final List<User> users;
  final bool noMoreData;

  UserDataLoaded({this.users, this.noMoreData}) : super([users, noMoreData]);

  UserDataLoaded copyWith({List<User> pusers, bool pnoMoreFlag}) {
    return UserDataLoaded(
        users: pusers ?? this.users,
        noMoreData: pnoMoreFlag ?? this.noMoreData);
  }

  @override
  String toString() {
    return 'UserDataLoaded {users.length:${users.length}, noMore?: $noMoreData}';
  }
}
