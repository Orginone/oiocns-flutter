import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  static SharedPreferences? _store;

  static Future<void>  instance() async {
    _store ??= await SharedPreferences.getInstance();;
  }

  static SharedPreferences getStore(){
    return _store!;
  }

}
