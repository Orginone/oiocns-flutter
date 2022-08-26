import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:orginone/page/home/component/personDetail/person_detail_binding.dart';
import 'package:orginone/page/home/component/personDetail/person_detail_page.dart';
import 'package:orginone/page/home/home_binding.dart';
import 'package:orginone/page/home/home_page.dart';
import 'package:orginone/page/home/message/chat/chat_binding.dart';
import 'package:orginone/page/home/message/chat/chat_page.dart';
import 'package:orginone/page/home/message/message_binding.dart';
import 'package:orginone/page/home/message/message_page.dart';
import 'package:orginone/page/home/message/setting/message_setting_binding.dart';
import 'package:orginone/page/home/message/setting/message_setting_page.dart';
import 'package:orginone/page/home/organization/cohorts/cohorts_binding.dart';
import 'package:orginone/page/home/organization/cohorts/cohorts_page.dart';
import 'package:orginone/page/home/organization/friends/friends_binding.dart';
import 'package:orginone/page/home/organization/friends/friends_page.dart';
import 'package:orginone/page/home/organization/groups/groups_binding.dart';
import 'package:orginone/page/home/organization/groups/groups_page.dart';
import 'package:orginone/page/home/organization/units/units_binding.dart';
import 'package:orginone/page/home/organization/units/units_page.dart';
import 'package:orginone/page/login/login_binding.dart';
import 'package:orginone/page/login/login_page.dart';
import 'package:orginone/page/register/register_binding.dart';
import 'package:orginone/page/register/register_page.dart';

class Routers {
  static const String main = "/";
  static const String register = "/register";
  static const String login = "/login";
  static const String home = "/home";
  static const String message = "/message";
  static const String chat = "/chat";
  static const String messageSetting = "/messageSetting";
  static const String friends = "/friends";
  static const String units = "/units";
  static const String groups = "/groups";
  static const String cohorts = "/cohorts";
  static const String personDetail = "/personDetail";

  static List<GetPage> getInitRouters() {
    return [
      GetPage(
          name: Routers.main,
          page: () => const LoginPage(),
          binding: LoginBinding()),
      GetPage(
          name: Routers.register,
          page: () => const RegisterPage(),
          binding: RegisterBinding()),
      GetPage(
          name: Routers.login,
          page: () => const LoginPage(),
          binding: LoginBinding()),
      GetPage(
          name: Routers.home,
          page: () => const HomePage(),
          binding: HomeBinding()),
      GetPage(
        name: Routers.message,
        page: () => const MessagePage(),
        binding: MessageBinding(),
      ),
      GetPage(
        name: Routers.chat,
        page: () => const ChatPage(),
        binding: ChatBinding(),
      ),
      GetPage(
        name: Routers.messageSetting,
        page: () => const MessageSettingPage(),
        binding: MessageSettingBinding(),
      ),
      GetPage(
        name: Routers.friends,
        page: () => const FriendsPage(),
        binding: FriendsBinding(),
      ),
      GetPage(
        name: Routers.units,
        page: () => const UnitsPage(),
        binding: UnitsBinding(),
      ),
      GetPage(
        name: Routers.groups,
        page: () => const GroupsPage(),
        binding: GroupsBinding(),
      ),
      GetPage(
        name: Routers.cohorts,
        page: () => const CohortsPage(),
        binding: CohortsBinding(),
      ),
      GetPage(
        name: Routers.personDetail,
        page: () => const PersonDetailPage(),
        binding: PersonDetailBinding(),
      )
    ];
  }
}
