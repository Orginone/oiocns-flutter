import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:orginone/page/home/component/personAdd/person_add_binding.dart';
import 'package:orginone/page/home/component/personAdd/person_add_page.dart';
import 'package:orginone/page/home/component/personDetail/person_detail_binding.dart';
import 'package:orginone/page/home/component/personDetail/person_detail_page.dart';
import 'package:orginone/page/home/component/space_choose/space_choose_binding.dart';
import 'package:orginone/page/home/component/space_choose/space_choose_page.dart';
import 'package:orginone/page/home/home_binding.dart';
import 'package:orginone/page/home/home_page.dart';
import 'package:orginone/page/home/message/chat/chat_binding.dart';
import 'package:orginone/page/home/message/chat/chat_page.dart';
import 'package:orginone/page/home/message/message_binding.dart';
import 'package:orginone/page/home/message/message_page.dart';
import 'package:orginone/page/home/message/messageSetting/message_setting_binding.dart';
import 'package:orginone/page/home/message/messageSetting/message_setting_page.dart';
import 'package:orginone/page/home/mine/mineInfo/mine_info_binding.dart';
import 'package:orginone/page/home/mine/mineInfo/mine_info_page.dart';
import 'package:orginone/page/home/mine/mine_binding.dart';
import 'package:orginone/page/home/mine/mine_page.dart';
import 'package:orginone/page/home/organization/cohorts/cohorts_binding.dart';
import 'package:orginone/page/home/organization/cohorts/cohorts_page.dart';
import 'package:orginone/page/home/organization/dept/dept_binding.dart';
import 'package:orginone/page/home/organization/dept/dept_page.dart';
import 'package:orginone/page/home/organization/friends/friends_binding.dart';
import 'package:orginone/page/home/organization/friends/friends_page.dart';
import 'package:orginone/page/home/organization/groups/groups_binding.dart';
import 'package:orginone/page/home/organization/groups/groups_page.dart';
import 'package:orginone/page/home/organization/organization_binding.dart';
import 'package:orginone/page/home/organization/organization_page.dart';
import 'package:orginone/page/home/organization/units/units_binding.dart';
import 'package:orginone/page/home/organization/units/units_page.dart';
import 'package:orginone/page/home/search/search_list.dart';
import 'package:orginone/page/home/search/search_page.dart';
import 'package:orginone/page/login/login_binding.dart';
import 'package:orginone/page/login/login_page.dart';
import 'package:orginone/page/register/register_binding.dart';
import 'package:orginone/page/register/register_page.dart';

class Routers {
  static const String main = "/";
  static const String register = "/register";
  static const String login = "/login";
  static const String home = "/home";
  static const String spaceChoose = "/spaceChoose";
  static const String message = "/message";
  static const String organization = "/organization";
  static const String chat = "/chat";
  static const String messageSetting = "/messageSetting";
  static const String friends = "/friends";
  static const String units = "/units";
  static const String groups = "/groups";
  static const String cohorts = "/cohorts";
  static const String dept = "/dept";
  static const String personDetail = "/personDetail";
  static const String personAdd = "/personAdd";
  static const String mine = "/mine";
  static const String mineInfo = "/mineInfo";
  static const String mineUnit = "/mineUnit";
  static const String search = "/search";

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
          name: Routers.spaceChoose,
          page: () => const SpaceChoosePage(),
          binding: SpaceChooseBinding()),
      GetPage(
        name: Routers.message,
        page: () => const MessagePage(),
        binding: MessageBinding(),
      ),
      GetPage(
        name: Routers.organization,
        page: () => const OrganizationPage(),
        binding: OrganizationBinding(),
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
        name: Routers.dept,
        page: () => const DeptPage(),
        binding: DeptBinding(),
      ),
      GetPage(
        name: Routers.personDetail,
        page: () => const PersonDetailPage(),
        binding: PersonDetailBinding(),
      ),
      GetPage(
        name: Routers.personAdd,
        page: () => const PersonAddPage(),
        binding: PersonAddBinding(),
      ),
      GetPage(
        name: Routers.mine,
        page: () => const MinePage(),
        binding: MineBinding(),
      ),
      GetPage(
        name: Routers.mineInfo,
        page: () => const MineInfoPage(),
        binding: MineInfoBinding(),
      ),
      GetPage(
        name: Routers.search,
        page: () => const SearchPage(),
        binding: SearchBinding(),
      ),
    ];
  }
}
