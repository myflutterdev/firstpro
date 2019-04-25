part of 'MyPageView.dart';

class UserListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyListView();

}

class _MyListView extends State<StatefulWidget> {
  List<User> infos = [];
  StreamController<List<User>> _streamCtl = StreamController();

//  RefreshIndicator _refreshCtl;

  Widget _refreshCtl() {
    return RefreshIndicator(
        displacement: 20,
        child: Scrollbar(
          child: ListView.separated(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(5),
            itemBuilder: (context, index) {
              return Container(
                color: Colors.white,
                height: 60,
                child: Text('Test ${infos[index].title}'),
              );
            },
            itemCount: infos.length,
            separatorBuilder: (context, index) {
              return Container(
                height: 2,
                color: Colors.black,
              );
            },

//          itemExtent: 60,
          ),
        ),
        onRefresh: () {
          debugPrint('fetch data >>>');

          return _loadData().then((temps) {
            debugPrint('got datas >>> ${temps.length}');
            setState(() {
              infos.addAll(temps);
              debugPrint('now datas >>> ${infos.length}');
            });
          });
        });
  }

//  _MyListView() {}

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  Future<List<User>> _loadData() async {
    http.Response resp =
        await http.get('https://jsonplaceholder.typicode.com/posts');
    if (resp.statusCode == 200) {
      List<dynamic> infos = jsonDecode(resp.body);
      List<User> users = [];
      for (Map info in infos) {
        users.add(User.fromJson(info));
      }
      return users;
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    return _buildMyList();
    debugPrint("load _refreshCtl");
    return _buildMyList();
  }

  Widget _buildMyList() {
    return StreamBuilder<List<User>>(
      stream: _streamCtl.stream,
      builder: (context, snapshot) {
        debugPrint('stream state :${snapshot.connectionState}');

        if (snapshot.hasData) {
          infos.addAll(snapshot.data);
          debugPrint('stream data cout :${snapshot.data.length}');
          return RefreshIndicator(
              child: Scrollbar(
                child: ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(5),
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.white,
                      height: 60,
                      child: Text('Test ${infos[index].title}'),
                    );
                  },
                  itemCount: infos.length,
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 2,
                      color: Colors.black,
                    );
                  },

//          itemExtent: 60,
                ),
              ),
              onRefresh: () {
                return _loadData().then((temps) {
                  _streamCtl.add(temps);
                });
              });
        } else {
          if (snapshot.hasError) {
            debugPrint("load fail: ${snapshot.error}");
            return Text('Load Fail');
          }
        }

        _loadData().then((temps) {
          _streamCtl.add(temps);
        });
        return Center(child: CircularProgressIndicator());
      },
    );

//    return ListView.builder(
//      itemBuilder: (context, index) {
//        return Container(
//          child: Text("test"),
//        );
//      },
//      itemCount: infos.length,
//      itemExtent: 60,
//    );
  }
}
