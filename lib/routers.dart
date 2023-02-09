import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:orginone/pages/other/login.dart';

class Routers {
  static const String main = "/";
  static const String login = "/login";
  static const String home = "/home";

  static List<GetPage> getInitRouters() {
    return [
      GetPage(
        name: Routers.main,
        page: () => const LoginPage(),
        binding: LoginBinding(),
      ),
      GetPage(
        name: Routers.home,
        page: () => const LoginPage(),
        binding: LoginBinding(),
      ),
    ];
  }
}
