import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:orginone/component/form.dart';
import 'package:orginone/page/forget/forget_binding.dart';
import 'package:orginone/page/forget/forget_page.dart';
import 'package:orginone/page/home/affairs/detail/affairs_detail.dart';
import 'package:orginone/page/home/center/center_binding.dart';
import 'package:orginone/page/home/center/center_page.dart';
import 'package:orginone/page/home/component/person_detail/person_detail_binding.dart';
import 'package:orginone/page/home/component/person_detail/person_detail_page.dart';
import 'package:orginone/page/home/component/person_add/person_add_binding.dart';
import 'package:orginone/page/home/component/person_add/person_add_page.dart';
import 'package:orginone/page/home/component/space_choose/space_choose_binding.dart';
import 'package:orginone/page/home/component/space_choose/space_choose_page.dart';
import 'package:orginone/page/home/component/unit/unit_create/unit_create_binding.dart';
import 'package:orginone/page/home/component/unit/unit_create/unit_create_page.dart';
import 'package:orginone/page/home/component/unit/unit_detail/unit_detail_binding.dart';
import 'package:orginone/page/home/component/unit/unit_detail/unit_detail_page.dart';
import 'package:orginone/page/home/home_binding.dart';
import 'package:orginone/page/home/home_page.dart';
import 'package:orginone/page/home/message/chat/chat_binding.dart';
import 'package:orginone/page/home/message/chat/chat_page.dart';
import 'package:orginone/page/home/message/contact/contact_binding.dart';
import 'package:orginone/page/home/message/contact/contact_page.dart';
import 'package:orginone/page/home/message/message_binding.dart';
import 'package:orginone/page/home/message/message_page.dart';
import 'package:orginone/page/home/message/message_setting/message_setting_binding.dart';
import 'package:orginone/page/home/message/message_setting/message_setting_page.dart';
import 'package:orginone/page/home/mine/mine_binding.dart';
import 'package:orginone/page/home/mine/mine_card/mine_card_binding.dart';
import 'package:orginone/page/home/mine/mine_card/mine_card_page.dart';
import 'package:orginone/page/home/mine/mine_info/mine_info_binding.dart';
import 'package:orginone/page/home/mine/mine_info/mine_info_page.dart';
import 'package:orginone/page/home/mine/mine_page.dart';
import 'package:orginone/page/home/mine/mine_unit/mine_unit_binding.dart';
import 'package:orginone/page/home/mine/mine_unit/mine_unit_page.dart';
import 'package:orginone/page/home/organization/cohorts/cohorts_binding.dart';
import 'package:orginone/page/home/organization/cohorts/cohorts_page.dart';
import 'package:orginone/page/home/organization/dept/dept_binding.dart';
import 'package:orginone/page/home/organization/dept/dept_page.dart';
import 'package:orginone/page/home/organization/friends/friend_add/friend_add_binding.dart';
import 'package:orginone/page/home/organization/friends/friend_add/friend_add_page.dart';
import 'package:orginone/page/home/organization/friends/friends_binding.dart';
import 'package:orginone/page/home/organization/friends/friends_page.dart';
import 'package:orginone/page/home/organization/groups/groups_binding.dart';
import 'package:orginone/page/home/organization/groups/groups_page.dart';
import 'package:orginone/page/home/organization/organization_binding.dart';
import 'package:orginone/page/home/organization/organization_page.dart';
import 'package:orginone/page/home/organization/units/units_binding.dart';
import 'package:orginone/page/home/organization/units/units_page.dart';
import 'package:orginone/page/home/search/search_binding.dart';
import 'package:orginone/page/home/search/search_page.dart';
import 'package:orginone/page/home/work/work_binding.dart';
import 'package:orginone/page/home/work/work_page.dart';
import 'package:orginone/page/login/login_binding.dart';
import 'package:orginone/page/login/login_page.dart';
import 'package:orginone/page/register/register_binding.dart';
import 'package:orginone/page/register/register_page.dart';
import 'package:orginone/page/scanning/scanning_binding.dart';
import 'package:orginone/page/scanning/scanning_page.dart';
import 'package:orginone/page/scanning/scanning_result/scanning_result_binding.dart';
import 'package:orginone/page/scanning/scanning_result/scanning_result_pge.dart';

import 'page/home/affairs/detail/affairs_detail_binding.dart';

class Routers {
  static const String main = "/";
  static const String forget = "/forget";
  static const String register = "/register";
  static const String login = "/login";
  static const String home = "/home";
  static const String spaceChoose = "/spaceChoose";
  static const String message = "/message";
  static const String organization = "/organization";
  static const String work = "/work";
  static const String chat = "/chat";
  static const String messageSetting = "/messageSetting";
  static const String friends = "/friends";
  static const String units = "/units";
  static const String groups = "/groups";
  static const String cohorts = "/cohorts";
  static const String dept = "/dept";
  static const String personDetail = "/person_detail";
  static const String personAdd = "/personAdd";
  static const String unitDetail = "/unitDetail";
  static const String unitCreate = "/unitCreate";
  static const String mine = "/mine";
  static const String mineInfo = "/mineInfo";
  static const String mineCard = "/mineCard";
  static const String mineUnit = "/mineUnit";
  static const String search = "/search";
  static const String scanning = "/scanning";
  static const String scanningResult = "/scanningResult";
  static const String contact = "/contact";
  //首页-办事
  static const String affairs = "/affairs";
  static const String friendAdd = "/friendAdd";
  static const String form = "/form";
  static const String affairsDetail = "/affairsDetail";

  static List<GetPage> getInitRouters() {
    return [
      GetPage(
          name: Routers.main,
          page: () => const LoginPage(),
          binding: LoginBinding()),
      GetPage(
          name: Routers.forget,
          page: () => const ForgetPage(),
          binding: ForgetBinding()),
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
          name: Routers.home,
          page: () => const CenterPage(),
          binding: CenterBinding()),
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
        name: Routers.work,
        page: () => const WorkPage(),
        binding: WorkBinding(),
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
        name: Routers.unitDetail,
        page: () => const UnitDetailPage(),
        binding: UnitDetailBinding(),
      ),
      GetPage(
        name: Routers.unitCreate,
        page: () => const UnitCreatePage(),
        binding: UnitCreateBinding(),
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
        name: Routers.mineCard,
        page: () => const MineCardPage(),
        binding: MineCardBinding(),
      ),
      GetPage(
        name: Routers.mineUnit,
        page: () => const MineUnitPage(),
        binding: MineUnitBinding(),
      ),
      GetPage(
        name: Routers.search,
        page: () => const SearchPage(),
        binding: SearchBinding(),
      ),
      GetPage(
        name: Routers.scanning,
        page: () => const ScanningPage(),
        binding: ScanningBinding(),
      ),
      GetPage(
        name: Routers.scanningResult,
        page: () => const ScanningResultPage(),
        binding: ScanningResultBinding(),
      ),
      GetPage(
        name: Routers.form,
        page: () => const Form(),
        binding: FormBinding(),
      ),
      GetPage(
        name: Routers.friendAdd,
        page: () => const FriendAddPage(),
        binding: FriendAddBinding(),
      ),
      GetPage(
        name: Routers.contact,
        page: () => const ContactPage(),
        binding: ContactBinding(),
      ),
      GetPage(
        name: Routers.affairsDetail,
        page: () => AffairsDetailPage(),
        binding: AffairsDetailBinding(),
      ),
    ];
  }
}
