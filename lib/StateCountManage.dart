import 'package:flutter/foundation.dart';

class StateCountManage with ChangeNotifier {
  int _stateCount = 0;
  StateCountManage({int count=0}){
    _stateCount = count;
  }

  int get stateCount => _stateCount;

  set stateCount(int stateCount) {
    _stateCount = stateCount;
    this.notifyListeners();
  }


}