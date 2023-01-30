import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:orginone/components/maintain_widget.dart';
import 'package:orginone/dart/controller/file_controller.dart';
import 'package:orginone/dart/controller/market/market_controller.dart';
import 'package:orginone/dart/controller/market/merchandise_controller.dart';
import 'package:orginone/dart/controller/market/order_controller.dart';
import 'package:orginone/dart/controller/market/staging_controller.dart';
import 'package:orginone/dart/controller/message/chat_box_controller.dart';
import 'package:orginone/dart/controller/message/message_controller.dart';
import 'package:orginone/dart/controller/target/target_controller.dart';
import 'package:orginone/pages/chat/chat/chat_page.dart';
import 'package:orginone/pages/chat/contact/contact_binding.dart';
import 'package:orginone/pages/chat/contact/contact_page.dart';
import 'package:orginone/pages/chat/invite/invite_page.dart';
import 'package:orginone/pages/chat/message_page.dart';
import 'package:orginone/pages/chat/message_setting/message_setting_page.dart';
import 'package:orginone/pages/chat/more_message/more_message_page.dart';
import 'package:orginone/pages/market/application/page/application_manager_page.dart';
import 'package:orginone/pages/market/application/page/application_page.dart';
import 'package:orginone/pages/market/market/market_page.dart';
import 'package:orginone/pages/market/market/merchandise_page.dart';
import 'package:orginone/pages/market/market/order_page.dart';
import 'package:orginone/pages/market/market/staging_page.dart';
import 'package:orginone/pages/other/center/center_binding.dart';
import 'package:orginone/pages/other/center/center_page.dart';
import 'package:orginone/pages/other/forget/forget_binding.dart';
import 'package:orginone/pages/other/forget/forget_page.dart';
import 'package:orginone/pages/other/home/home_binding.dart';
import 'package:orginone/pages/other/home/home_page.dart';
import 'package:orginone/pages/other/login/login_binding.dart';
import 'package:orginone/pages/other/login/login_page.dart';
import 'package:orginone/pages/other/register/register_binding.dart';
import 'package:orginone/pages/other/register/register_page.dart';
import 'package:orginone/pages/other/scanning/scanning_binding.dart';
import 'package:orginone/pages/other/scanning/scanning_page.dart';
import 'package:orginone/pages/other/scanning/scanning_result/scanning_result_binding.dart';
import 'package:orginone/pages/other/scanning/scanning_result/scanning_result_pge.dart';
import 'package:orginone/pages/other/search/search_binding.dart';
import 'package:orginone/pages/other/search/search_page.dart';
import 'package:orginone/pages/setting/mine/mine_binding.dart';
import 'package:orginone/pages/setting/mine/mine_card/mine_card_binding.dart';
import 'package:orginone/pages/setting/mine/mine_card/mine_card_page.dart';
import 'package:orginone/pages/setting/mine/mine_info/mine_info_binding.dart';
import 'package:orginone/pages/setting/mine/mine_info/mine_info_page.dart';
import 'package:orginone/pages/setting/mine/mine_page.dart';
import 'package:orginone/pages/setting/mine/mine_unit/mine_unit_page.dart';
import 'package:orginone/pages/setting/mine/set_home/set_home_binding.dart';
import 'package:orginone/pages/setting/mine/set_home/set_home_page.dart';
import 'package:orginone/pages/setting/mine/version/publisher_controller.dart';
import 'package:orginone/pages/setting/mine/version/publisher_page.dart';
import 'package:orginone/pages/setting/mine/version/version_controller.dart';
import 'package:orginone/pages/setting/mine/version/version_page.dart';
import 'package:orginone/pages/setting/organization/cohorts/cohorts_page.dart';
import 'package:orginone/pages/setting/organization/cohorts/component/more_cohort.dart';
import 'package:orginone/pages/setting/organization/dept/dept_binding.dart';
import 'package:orginone/pages/setting/organization/dept/dept_page.dart';
import 'package:orginone/pages/setting/organization/friends/friend_add/friend_add_binding.dart';
import 'package:orginone/pages/setting/organization/friends/friend_add/friend_add_page.dart';
import 'package:orginone/pages/setting/organization/friends/friends_binding.dart';
import 'package:orginone/pages/setting/organization/friends/friends_page.dart';
import 'package:orginone/pages/setting/organization/friends/new_friend/new_friend_page.dart';
import 'package:orginone/pages/setting/organization/friends/new_friend/new_friends_binding.dart';
import 'package:orginone/pages/setting/organization/groups/groups_binding.dart';
import 'package:orginone/pages/setting/organization/groups/groups_page.dart';
import 'package:orginone/pages/setting/organization/organization_binding.dart';
import 'package:orginone/pages/setting/organization/organization_page.dart';
import 'package:orginone/pages/setting/organization/units/units_binding.dart';
import 'package:orginone/pages/setting/organization/units/units_page.dart';
import 'package:orginone/pages/setting/person_add/person_add_binding.dart';
import 'package:orginone/pages/setting/person_add/person_add_page.dart';
import 'package:orginone/pages/setting/person_detail/person_detail_binding.dart';
import 'package:orginone/pages/setting/person_detail/person_detail_page.dart';
import 'package:orginone/pages/setting/space_choose/space_choose_page.dart';
import 'package:orginone/pages/setting/unit/unit_create/unit_create_binding.dart';
import 'package:orginone/pages/setting/unit/unit_create/unit_create_page.dart';
import 'package:orginone/pages/setting/unit/unit_detail/unit_detail_page.dart';
import 'package:orginone/pages/work/affairs/detail/affairs_detail.dart';
import 'package:orginone/pages/work/affairs/detail/affairs_detail_binding.dart';

class Routers {
  static const String main = "/";
  static const String forget = "/forget";
  static const String register = "/register";
  static const String login = "/login";
  static const String home = "/home";
  static const String center = "/center";
  static const String spaceChoose = "/spaceChoose";
  static const String maintain = "/maintain";

  // 会话
  static const String message = "/message";
  static const String chat = "/chat";
  static const String moreMessage = "/moreMessage";
  static const String organization = "/organization";
  static const String messageSetting = "/messageSetting";
  static const String friends = "/friends";
  static const String units = "/units";
  static const String groups = "/groups";
  static const String cohorts = "/cohorts";
  static const String moreCohort = "/moreCohort";
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
  static const String invite = "/invite";
  static const String affairsDetail = "/affairsDetail";
  static const String newFriends = "/newFriends";
  static const String setHome = "/setHome";
  static const String publisher = "/publisher";

  // 仓库
  static const String application = "/application";
  static const String manager = "/applicationManager";
  static const String merchandise = "/applicationMerchandise";
  static const String marketMaintain = "/marketMaintain";
  static const String market = "/market";
  static const String staging = "/staging";
  static const String order = "/order";

  //设置
  static const String version = "/version";

  static List<GetPage> getInitRouters() {
    return [
      GetPage(
        name: Routers.main,
        page: () => const LoginPage(),
        binding: LoginBinding(),
      ),
      GetPage(
        name: Routers.forget,
        page: () => const ForgetPage(),
        binding: ForgetBinding(),
      ),
      GetPage(
        name: Routers.register,
        page: () => const RegisterPage(),
        binding: RegisterBinding(),
      ),
      GetPage(
        name: Routers.login,
        page: () => const LoginPage(),
        binding: LoginBinding(),
      ),
      GetPage(
        name: Routers.home,
        page: () => const HomePage(),
        binding: HomeBinding(),
      ),
      GetPage(
        name: Routers.center,
        page: () => const CenterPage(),
        binding: CenterBinding(),
      ),
      GetPage(
        name: Routers.spaceChoose,
        page: () => const SpaceChoosePage(),
        binding: TargetBinding(),
      ),
      GetPage(
        name: Routers.message,
        page: () => const MessagePage(),
        binding: MessageBinding(),
      ),
      GetPage(
        name: Routers.moreMessage,
        page: () => const MoreMessagePage(),
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
        bindings: [MessageBinding(), ChatBoxBinding()],
      ),
      GetPage(
        name: Routers.messageSetting,
        page: () => const MessageSettingPage(),
        binding: MessageBinding(),
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
        binding: TargetBinding(),
      ),
      GetPage(
        name: Routers.moreCohort,
        page: () => const MoreCohort(),
        binding: TargetBinding(),
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
        binding: TargetBinding(),
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
        binding: TargetBinding(),
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
      GetPage(
        name: Routers.newFriends,
        page: () => const NewFriendsPage(),
        binding: NewFriendsBinding(),
      ),
      GetPage(
        name: Routers.invite,
        page: () => const InvitePage(),
        binding: InviteBinding(),
      ),
      GetPage(
        name: Routers.setHome,
        page: () => SetHomePage(),
        binding: SetHomeBinding(),
      ),
      GetPage(
        name: Routers.application,
        page: () => const ApplicationPage(),
        binding: ApplicationBinding(),
      ),
      GetPage(
        name: Routers.application,
        page: () => const ApplicationPage(),
        binding: ApplicationBinding(),
      ),
      GetPage(
        name: Routers.manager,
        page: () => const ApplicationManagerPage(),
        binding: ApplicationManagerBinding(),
      ),
      GetPage(
        name: Routers.merchandise,
        page: () => const MerchandisePage(),
        bindings: [MerchandiseBinding(), StagingBinding(), MessageBinding()],
      ),
      GetPage(
        name: Routers.marketMaintain,
        page: () => const MaintainPage(),
        binding: ApplicationBinding(),
      ),
      GetPage(
        name: Routers.market,
        page: () => const MarketPage(),
        binding: MarketBinding(),
      ),
      GetPage(
        name: Routers.staging,
        page: () => const StagingPage(),
        bindings: [StagingBinding(), MessageBinding(), OrderBinding()],
      ),
      GetPage(
        name: Routers.order,
        page: () => const OrderPage(),
        bindings: [OrderBinding()],
      ),
      GetPage(
        name: Routers.order,
        page: () => const OrderPage(),
        bindings: [OrderBinding()],
      ),
      GetPage(
        name: Routers.maintain,
        page: () => const MaintainPage(),
        bindings: [
          TargetBinding(),
          MessageBinding(),
          MarketBinding(),
          FileBinding()
        ],
      ),
      GetPage(
        name: Routers.version,
        page: () => const VersionPage(),
        binding: VersionBinding(),
      ),
      GetPage(
        name: Routers.publisher,
        page: () => PublisherPage(),
        binding: PublisherBinding(),
      ),
    ];
  }
}
