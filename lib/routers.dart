import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:orginone/dart/controller/chat/chat_controller.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/pages/chat/message_chat_page.dart';
import 'package:orginone/pages/chat/message_more.dart';
import 'package:orginone/pages/chat/message_page.dart';
import 'package:orginone/pages/chat/widgets/chat_box.dart';
import 'package:orginone/pages/chat/widgets/detail_item_widget.dart';
<<<<<<< HEAD
import 'package:orginone/pages/index/index_page.dart';
// import 'package:orginone/pages/index/indexok_page.dart';
=======
>>>>>>> main
import 'package:orginone/pages/other/home/home_page.dart';
import 'package:orginone/pages/other/home/spaces_page.dart';
import 'package:orginone/pages/other/login.dart';
import 'package:orginone/pages/other/scanning/scanning_page.dart';
import 'package:orginone/pages/other/scanning/scanning_result_pge.dart';
import 'package:orginone/pages/other/search_page.dart';
import 'package:orginone/pages/setting/contact_page.dart';
import 'package:orginone/pages/setting/mine_unit_page.dart';
import 'package:orginone/pages/setting/new_friend_page.dart';
import 'package:orginone/pages/setting/set_home_page.dart';
<<<<<<< HEAD
import 'package:orginone/pages/setting/unit_settings_page.dart';
=======
>>>>>>> main

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

<<<<<<< HEAD
  // 首页
  static const String index = "/index";

=======
>>>>>>> main
  // 设置
  static const String mineUnit = "/mineUnit";
  static const String newFriends = "/newFriends";
  static const String contact = "/contact";
  static const String cohorts = "/cohorts";
<<<<<<< HEAD
  static const String uintSettings = "/uintSettings";
=======
>>>>>>> main

  static List<GetPage> getInitRouters() {
    return [
      GetPage(
        name: Routers.main,
        page: () => const LoginPage(),
        bindings: [SettingBinding(), ChatBinding(), LoginBinding()],
      ),
      GetPage(
        name: Routers.home,
        page: () => const HomePage(),
<<<<<<< HEAD
        bindings: [
          ChatBinding(),
          HomeBinding(),
          SetHomeBinding(),
          MessageBinding(),
          IndexPageBinding()
        ],
=======
        bindings: [HomeBinding(), SetHomeBinding(), MessageBinding()],
>>>>>>> main
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
        name: Routers.chat,
        page: () => const ChatPage(),
        bindings: [ChatBoxBinding(), PlayBinding()],
      ),
      GetPage(
        name: Routers.moreMessage,
        page: () => const MoreMessagePage(),
      ),
      GetPage(
        name: Routers.mineUnit,
        page: () => const MineUnitPage(),
      ),
      GetPage(
        name: Routers.newFriends,
        page: () => const NewFriendsPage(),
        binding: NewFriendsBinding(),
      ),
      GetPage(
        name: Routers.contact,
        page: () => const ContactPage(),
        binding: ContactBinding(),
      ),
      GetPage(
        name: Routers.cohorts,
        page: () => const ContactPage(),
        binding: ContactBinding(),
<<<<<<< HEAD
      ),
      GetPage(
        name: Routers.uintSettings,
        page: () => UintSettingsPage(),
        binding: UintSettingsBinding(),
      ),
      GetPage(
        name: Routers.index,
        page: () => IndexPage(),
        bindings: [
          HomeBinding(),
          IndexPageBinding(),
          ChatBinding(),
          MessageBinding(),
          ChatBoxBinding(),
          PlayBinding(),
          SetHomeBinding(),
        ],
=======
>>>>>>> main
      ),
    ];
  }
}
