import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyCustomButton extends StatelessWidget {
  MyCustomButton({@required this.onPressed});

  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RawMaterialButton(
      onPressed: onPressed,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: buildButtonRow()),
      fillColor: Colors.orange,
      splashColor: Colors.deepOrange,
      shape: const StadiumBorder(
          side: BorderSide(
              width: 2, color: Colors.purple, style: BorderStyle.solid)),
    );
  }

  Row buildButtonRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        RotatedBox(
          quarterTurns: 1,
          child: Icon(Icons.explore, color: Colors.white),
        ),
        SizedBox(
          width: 10,
        ),
        Text("TestAddCount",
            style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 20)),
      ],
    );
  }
}
