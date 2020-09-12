import 'package:bot_toast/bot_toast.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';

void main() => runApp(Example());

class Example extends StatefulWidget {
  Example({Key key}) : super(key: key);

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  Future onBackClick() async {
    print('back~·');
    BotToast.showText(text: 'Tap back again to leave');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()],
      home: Scaffold(
        body: DoubleBackToCloseApp(
          onBackShow: onBackClick,
          child: Center(
            child: OutlineButton(
              child: const Text('Tap to simulate back'),
              // ignore: invalid_use_of_protected_member
              onPressed: WidgetsBinding.instance.handlePopRoute,
            ),
          ),
        ),
      ),
    );
  }
}

// class Example extends StatelessWidget {

//   dynamic onBackClick() {
//     showDialog(context: context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: DoubleBackToCloseApp(
//           snackBar: const SnackBar(
//             content: Text('Tap back again to leave'),
//           ),
//           onBackShow: onBackClick,
//           child: Center(
//             child: OutlineButton(
//               child: const Text('Tap to simulate back'),
//               // ignore: invalid_use_of_protected_member
//               onPressed: WidgetsBinding.instance.handlePopRoute,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
