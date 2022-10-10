import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper{
  static showToast(String msg) async {
    await Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        fontSize: 16.0
    );
  }
}
