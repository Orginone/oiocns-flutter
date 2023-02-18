import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:orginone/dart/controller/chat/index.dart';
import 'package:orginone/dart/controller/setting/index.dart';
import 'package:orginone/pages/chat/message_more.dart';
import 'package:orginone/pages/chat/message_page.dart';
import 'package:orginone/pages/other/home/home_page.dart';
import 'package:orginone/pages/other/home/spaces_page.dart';
import 'package:orginone/pages/other/login.dart';
import 'package:orginone/pages/other/scanning/scanning_page.dart';
import 'package:orginone/pages/other/scanning/scanning_result_pge.dart';
import 'package:orginone/pages/other/search_page.dart';
import 'package:orginone/pages/setting/set_home_page.dart';

class Routers {
  // 入口页面
  static const String main = "/";

  // 首页
  static const String home = "/home";

  // 登录
  static const String login = "/login";

  // 空间选择
  static const String spaces = "/login";

  // 简单表单编辑器
  static const String form = "/form";

  // 二维码扫描
  static const String scanning = "/scanning";
  static const String scanningResult = "/scanningResult";

  // 搜索
  static const String search = "/search";
  static const String searchResult = "/searchResult";

  // 消息
  static const String messageSetting = "/messageSetting";
  static const String message = "/message";
  static const String chat = "/chat";
  static const String moreMessage = "/moreMessage";

  static List<GetPage> getInitRouters() {
    return [
      GetPage(
        name: Routers.main,
        page: () => LoginPage(),
        bindings: [SettingBinding(), ChatBinding()],
      ),
      GetPage(
        name: Routers.home,
        page: () => const HomePage(),
        bindings: [HomeBinding(), SetHomeBinding(), MessageBinding()],
      ),
      GetPage(
        name: Routers.spaces,
        page: () => const SpacesPage(),
        binding: SettingBinding(),
      ),
      GetPage(
        name: Routers.scanning,
        page: () => const ScanningPage(),
        binding: ScanningBinding(),
      ),
      GetPage(
        name: Routers.spaces,
        page: () => const ScanningResultPage(),
        binding: ScanningResultBinding(),
      ),
      GetPage(
        name: Routers.search,
        page: () => const SearchPage(),
        binding: SearchBinding(),
      ),
      GetPage(
        name: Routers.searchResult,
        page: () => const ScanningResultPage(),
        binding: ScanningResultBinding(),
      ),
      GetPage(
        name: Routers.moreMessage,
        page: () => const MoreMessagePage(),
      ),
    ];
  }
}
