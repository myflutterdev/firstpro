part of 'MyCustomButton.dart';

class MyCustomTextView extends StatelessWidget {
  const MyCustomTextView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StateCountManage>(
      builder: (context, value, _) => Container(
            child: Text("Total: ${value.stateCount}",
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 22)),
          ),
      // child: Container(
      //   child: Text("TotalC: ",
      //       style: TextStyle(
      //           color: Colors.white,
      //           fontStyle: FontStyle.italic,
      //           fontSize: 22)),
      // ),
    );
  }
}
