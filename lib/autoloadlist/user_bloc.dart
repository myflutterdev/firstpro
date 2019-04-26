import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'bloc_exp.dart';
import 'package:myapp/user.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class UserBloc extends Bloc<UserDataEvent, UserDataState> {
  final http.Client httpClient; // = http.Client();
  UserBloc({@required this.httpClient});

  @override
  UserDataState get initialState => UserDataUnInit();

  @override
  Stream<UserDataState> mapEventToState(UserDataEvent event) async* {
    if (event is FetchUser && !_hasNoMoreData()) {
      try {
        if (currentState is UserDataUnInit) {
          final datas = await _fetchData(0, 20);
          yield UserDataLoaded(users: datas, noMoreData: false);
          return;
        }

        if (currentState is UserDataLoaded) {
          final datas = await _fetchData(
              (currentState as UserDataLoaded).users.length, 20);

          if (datas.isEmpty) {
            yield (currentState as UserDataLoaded).copyWith(pnoMoreFlag: true);
          } else {
            yield UserDataLoaded(
                users: (currentState as UserDataLoaded).users + datas,
                noMoreData: false);
          }
        }
      } catch (_) {
        yield UserDataError();
      }
    }

    return;
  }

  bool _hasNoMoreData() {
    return this.currentState is UserDataLoaded &&
        (this.currentState as UserDataLoaded).noMoreData;
  }

  Future<List<User>> _fetchData(int startIndex, int limit) async {
    final http.Response resp = await httpClient.get(
        'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit');
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body) as List;
      return data.map((info) {
        return User.fromJson(info);
      }).toList();
    } else {
      throw Exception('error fetching data!');
    }
  }

  @override
  Stream<UserDataState> transform(Stream<UserDataEvent> events,
      Stream<UserDataState> Function(UserDataEvent event) next) {
    return super.transform(
        (events as Observable<UserDataEvent>)
            .debounce(Duration(milliseconds: 500)),
        next);
  }
}
