import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'user.dart';

part 'UserListView.dart';

class MyPageView extends StatelessWidget {

  const MyPageView({@required this.mcontext, this.mtitle = '123'});
  final BuildContext mcontext;
  final String mtitle;

//  Future<User> demoFetch;


  static const platform = const MethodChannel('test.flutter.io/jump');

  static const jmpMethodName = 'jumpFromFlutter:';

  _naviBack() {
    Navigator.pop(mcontext);
  }

  _emptyCall() {}

  _testTriggerMore() {
    debugPrint("trigger more:");
  }

  Future<User> _testFetch() async {
    final resp = await http.get('https://jsonplaceholder.typicode.com/posts/1');
    if (resp.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      Map jsonInfo = jsonDecode(resp.body);
      User info = User.fromJson(jsonInfo);
      return info;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  _testChannelCommunicate() async {
    if (Platform.isIOS) {
      debugPrint('right in ios');
    }

    try {
      final dynamic resl = await platform
          .invokeMethod(jmpMethodName, {'param1': 'val1', 'param2': 'val2'});
      debugPrint("native return: $resl");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      debugPrint('Done!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.green,
      bottomNavigationBar: BottomAppBar(color: Colors.white, child: Container(height: 0,),),
      appBar: AppBar(
        title: Text(mtitle),

        leading: FlatButton(
            onPressed: _naviBack,
            textColor: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.arrow_back_ios,
                ),
//                Text('Back')
              ],
            )),
//        leading: FlatButton.icon(
//          onPressed: _naviBack,
//          icon: Icon(Icons.arrow_back_ios),
//          label: Text('Back', style: Theme.of(context).textTheme.button,),
//          textColor: Colors.white,
//        ),
      ),
      body: Center(
        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 30)),
            RaisedButton(
//              padding: EdgeInsets.only(top: 30),
              onPressed: _testChannelCommunicate,
              color: Colors.blue,
              splashColor: Colors.lightBlue,
              child: Text(
                'ChannelTest',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
//              constraints: BoxConstraints.expand(width: 200),
              child: RaisedButton(
                padding: EdgeInsets.all(20),
                onPressed: _emptyCall,
                color: Colors.blue,
                splashColor: Colors.lightBlue,
                child: FutureBuilder<User>(
                  future: _testFetch(),
                  builder: (context, snapshot) {
                    debugPrint("state snapshot: ${snapshot.connectionState}");

                    if (snapshot.hasData) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Got data: ${snapshot.data.toJson()}"),
                          RawMaterialButton(
                            fillColor: Colors.orange,
                            splashColor: Colors.deepOrange,
                            onPressed: _testTriggerMore,
                            child: Text("LoadMore"),
                            textStyle:
                                Theme.of(mcontext).primaryTextTheme.button,
                          ),
//                          UserListView(),

//                          Expanded(child: UserListView()),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("Err: ${snapshot.error}");
                    }

                    // By default, show a loading spinner
                    return CircularProgressIndicator();
                  },
                ),

//              child: Text(
//                'FetchHttp',
//                style: TextStyle(color: Colors.white),
//              ),
              ),
            ),

            Expanded(child: UserListView()),

          ],

        ),
      ),
    );
  }
}
