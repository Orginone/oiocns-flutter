import 'package:hive/hive.dart';
import 'package:orginone/model/user_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveUtils {
  static late Box _userBox;

  static Future<void> init() async {
    var document = await getApplicationDocumentsDirectory();
    Hive.init(document.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive
        ..registerAdapter(UserModelAdapter())
        ..registerAdapter(AttrsAdapter())
        ..registerAdapter(PersonAdapter())
        ..registerAdapter(TeamAdapter());
    }

    _userBox = await Hive.openBox('userBox');
  }

  static void putUser(UserModel user) async {
    await _userBox.put("user", user);
  }

  static UserModel? getUser() {
    return _userBox.get("user");
  }

  static Future<void> clean() async{
    await _userBox.clear();
  }
}
