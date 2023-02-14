import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:orginone/dart/ts/controller/setting/index.dart';
import 'package:orginone/pages/other/home/home_page.dart';
import 'package:orginone/pages/other/login.dart';

class Routers {
  static const String main = "/";
  static const String home = "/home";
  static const String login = "/login";
  static const String spaces = "/login";

  static List<GetPage> getInitRouters() {
    return [
      GetPage(
        name: Routers.main,
        page: () => const HomePage(),
        bindings: [SettingBinding()],
      ),
      GetPage(
        name: Routers.login,
        page: () => const LoginPage(),
        binding: LoginBinding(),
      ),
      GetPage(
        name: Routers.spaces,
        page: () => const LoginPage(),
        binding: LoginBinding(),
      ),
    ];
  }
}
