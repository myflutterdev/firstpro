// This example shows a [Scaffold] with an [AppBar], a [BottomAppBar] and a
// [FloatingActionButton]. The [body] is a [Text] placed in a [Center] in order
// to center the text within the [Scaffold] and the [FloatingActionButton] is
// centered and docked within the [BottomAppBar] using
// [FloatingActionButtonLocation.centerDocked]. The [FloatingActionButton] is
// connected to a callback that increments a counter.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/animated_list.dart';
import 'MyCustomButton.dart';

import 'MyPageView.dart';
import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';

import 'StateCountManage.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    super.onTransition(transition);
    print(transition);
  }
}

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

void _testSwitchApp() {
  runApp(AnimatedListSample());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StateCountManage>.value(
          value: StateCountManage(),
        ),
        
      ],
      child: MaterialApp(
        title: 'Flutter Code Sample for material.Scaffold',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: MyStatefulWidget(),
        routes: <String, WidgetBuilder>{
          '/odd': (BuildContext context) => MyPageView(
                mcontext: context,
                mtitle: 'Odd',
              ),
          '/even': (BuildContext context) => MyPageView(
                mcontext: context,
                mtitle: 'Even',
              ),
        },
//      debugShowMaterialGrid: true,
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _count = 0;
  String _message = '';

  final double _rowHeight = 60;
  ScrollController _scrollCtrl;
  final _myListKey = GlobalKey<AnimatedListState>();

  _MyStatefulWidgetState();

  @override
  void initState() {
    debugPrint('initial');
    _scrollCtrl = ScrollController(initialScrollOffset: 0);
    _scrollCtrl.addListener(_msrcollListener);
    setState(() {
      _message = 'iniial';
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    debugPrint('disposed');
    setState(() {
      _message = 'disposed';
    });
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _msrcollListener() {
    //debugPrint('notify scroll');
    setState(() {
      _message = 'scrolling';
    });

    if (_scrollCtrl.offset >= _scrollCtrl.position.maxScrollExtent ||
        (_scrollCtrl.offset > 0 && _scrollCtrl.position.outOfRange)) {
      setState(() {
        _message = "reach the bottom";
      });
    }
    if (_scrollCtrl.offset <= 0) {
      setState(() {
        _message = "reach the top";
      });
    }
  }

  void _testNavi(int index) {
    // _testSwitchApp();
    // return ;
    
    if (index % 2 == 0) {
      Navigator.pushNamed(context, '/even');
    } else {
      Navigator.pushNamed(context, '/odd');
    }

    return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyPageView(
                  mcontext: context,
                  mtitle: 'title $index',
                )));
  }

  Widget _dialogBuilder(BuildContext context, int index) {
    return SimpleDialog(
      title: Center(child: Text('Clicked $index')),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      titlePadding: EdgeInsets.only(top: 10),
      children: <Widget>[
        Container(
          width: 200,
          height: 100,
          color: Colors.amberAccent,
        ),
        Center(
            child: Text(
          'Content Sample',
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RaisedButton(
              onPressed: () => _testNavi(index),
              color: Colors.blue,
              splashColor: Colors.lightBlue,
              child: Text(
                'NaviTest',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20)),
          ],
        )
      ],
    );
  }

  Widget _listItemBuilder(BuildContext context, int index, {Animation anim}) {
    return GestureDetector(
      onTap: () => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => _dialogBuilder(context, index)),
      child: SizeTransition(
        sizeFactor: anim,
        axis: Axis.vertical,
        child: Container(
            color: Colors.transparent, //can enable whole cell tap action
            height: 60,
            padding: EdgeInsets.all(5),
            child: Center(
                child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Cell Data $index of total $_count',
                    style: Theme.of(context).textTheme.headline),
              ],
            ))),
      ),
    );
  }

  void _clearAllData() {
    setState(() {
      // int temp = _count;
      // _count = 0;

      int index = _count - 1;
      if (_count > 0) {
        _myListKey.currentState.removeItem(
            index,
            (context, animation) =>
                _listItemBuilder(context, index, anim: animation));
        // index++;
        _count--;
      }

      StateCountManage countMan = Provider.of<StateCountManage>(context);
      countMan.stateCount = _count;
    });
  }

  void _increaseCount() {
    setState(() {
      _count++;
      _myListKey.currentState.insertItem(0);
      StateCountManage countMan = Provider.of<StateCountManage>(context);
      countMan.stateCount = _count;
      // _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent + _rowHeight);
      // _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent + _rowHeight, duration: Duration(milliseconds: 500), curve: Curves.bounceInOut);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sample Code12345'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear_all),
            tooltip: "Clear",
            onPressed: _clearAllData,
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text('total_count: $_count, $_message'),
              GestureDetector(
                onTap: () => _scrollCtrl.jumpTo(0),
                child: Container(
                  height: 40,
                  color: Colors.deepOrange,
                  child: Center(
                      child: Text(
                    'Scroll to top',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
              Expanded(
                child: buildListView,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 44.0,
        ),
      ),

      floatingActionButton: MyCustomButton(
        onPressed: _increaseCount,
      ),

//      floatingActionButton: FloatingActionButton(
//        onPressed: () => setState(() {
//              _count++;
//            }),
//        tooltip: 'Increment Counter',
//        child: Icon(Icons.add),
//      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Scrollbar get buildListView {
    return Scrollbar(
      child: AnimatedList(
        // initialItemCount: _count,
        key: _myListKey,
        itemBuilder: (context, index, animation) =>
            _listItemBuilder(context, index, anim: animation),
        controller: _scrollCtrl,
      ),
//       child: ListView.separated(
//         separatorBuilder: (context, index) {
//           return Divider(
//             indent: 0,
//           );
//         },
//         itemBuilder: _listItemBuilder,
//         itemCount: _count,
// //        itemExtent: _rowHeight,
//         controller: _scrollCtrl,
//       ),
    );
  }
}
