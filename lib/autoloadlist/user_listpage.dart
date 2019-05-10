import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/user.dart';
import 'bloc_exp.dart';

class TestUserList extends StatefulWidget {
  TestUserList({Key key}) : super(key: key);

  TestUserListState createState() => TestUserListState();
}

class TestUserListState extends State<TestUserList> {
  final _scrollCtl = ScrollController();
  final userbloc = UserBloc(httpClient: http.Client());
  final _scrollThreshold = 200.0;

  TestUserListState() {
    userbloc.dispatch(FetchUser());
    _scrollCtl.addListener(_onScroll);
  }

  @override
  void dispose() {
    debugPrint('list dispose');
    userbloc.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    debugPrint('deactive');
    super.deactivate();
  }

  void _onScroll() {
    final maxOffset = _scrollCtl.position.maxScrollExtent;
    final currentPos = _scrollCtl.position.pixels;
    if (maxOffset - currentPos <= _scrollThreshold) {
      userbloc.dispatch(FetchUser());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: userbloc,
      builder: (BuildContext context, UserDataState state) {
        if (state is UserDataUnInit) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is UserDataError) {
          return Center(
            child: Text('load failed'),
          );
        } else if (state is UserDataLoaded) {
          if (state.users.isEmpty) {
            return Center(
              child: Text('no datas'),
            );
          }

          return ListView.separated(
            separatorBuilder: (context, index) {
              return Container(
                height: 1,
                color: Colors.grey,
              );
            },
            itemCount:
                state.noMoreData ? state.users.length : state.users.length + 1,
            itemBuilder: (_, index) {
              if (index == state.users.length) {
                return _bottomLoader();
              }
              return _cellWidget(state.users[index]);
            },
            controller: _scrollCtl,
          );
        }
      },
    );
  }

  Widget _bottomLoader() {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
            )),
      ),
    );
  }

  Widget _cellWidget(User user) {
    return ListTile(
      leading: Text('${user.id}', style: TextStyle(fontSize: 10),),
      title: Text('${user.title}'),
      isThreeLine: true,
      subtitle: Text('${user.body}'),
      dense: true,
    );
  }
}
