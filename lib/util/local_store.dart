import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  static SharedPreferences? store;

  static Future<SharedPreferences> get instance async {
    store ??= await SharedPreferences.getInstance();
    return store!;
  }
}
