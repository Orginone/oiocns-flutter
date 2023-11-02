import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static Future<void> showMsg({required String msg}) {
    return Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT);
  }

  static Future<void> dismiss() {
    return Fluttertoast.cancel();
  }
}
