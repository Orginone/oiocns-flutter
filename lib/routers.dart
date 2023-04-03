import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:orginone/dart/controller/chat/chat_controller.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/pages/chat/message_chat_page.dart';
import 'package:orginone/pages/chat/message_more.dart';
import 'package:orginone/pages/chat/message_page.dart';
import 'package:orginone/pages/chat/widgets/chat_box.dart';
import 'package:orginone/pages/chat/widgets/detail_item_widget.dart';
import 'package:orginone/pages/index/index_page.dart';
import 'package:orginone/pages/index/news/searchBarWidget.dart';
// import 'package:orginone/pages/index/indexok_page.dart';
import 'package:orginone/pages/other/add_asset/binding.dart';
import 'package:orginone/pages/other/add_asset/view.dart';
import 'package:orginone/pages/other/choice_department/binding.dart';
import 'package:orginone/pages/other/choice_department/view.dart';
import 'package:orginone/pages/other/choice_people/binding.dart';
import 'package:orginone/pages/other/choice_people/view.dart';
import 'package:orginone/pages/other/choice_thing/binding.dart';
import 'package:orginone/pages/other/file/view.dart';
import 'package:orginone/pages/other/home/home_page.dart';
import 'package:orginone/pages/other/home/spaces_page.dart';
import 'package:orginone/pages/other/login.dart';
import 'package:orginone/pages/other/qr_scan/binding.dart';
import 'package:orginone/pages/other/qr_scan/view.dart';
import 'package:orginone/pages/other/scanning/scanning_page.dart';
import 'package:orginone/pages/other/scanning/scanning_result_pge.dart';
import 'package:orginone/pages/other/search_page.dart';
import 'package:orginone/pages/other/web_view/binding.dart';
import 'package:orginone/pages/other/web_view/view.dart';
import 'package:orginone/pages/other/work/work_start/view.dart';
import 'package:orginone/pages/setting/contact_page.dart';
import 'package:orginone/pages/setting/home/binding.dart';
import 'package:orginone/pages/setting/home/view.dart';
import 'package:orginone/pages/setting/mine_unit_page.dart';
import 'package:orginone/pages/setting/new_friend_page.dart';
import 'package:orginone/pages/setting/person/view.dart';
import 'package:orginone/pages/setting/publisher_page.dart';
import 'package:orginone/pages/setting/set_home_page.dart';
import 'package:orginone/pages/setting/unit_settings_page.dart';
import 'package:orginone/pages/setting/version_page.dart';
import 'package:orginone/pages/todo/todo_detail.dart';
import 'package:orginone/pages/todo/todo_tab_page.dart';
import 'package:orginone/pages/todo/work_page.dart';
import 'package:orginone/pages/todo/workbench_page.dart';
import 'package:orginone/util/hive_utils.dart';

import './pages/other/home/ware_house/assets_management/assets_management_binding.dart';

// 资产管理
import './pages/other/home/ware_house/assets_management/assets_management_page.dart';
import './pages/other/home/ware_house/market/market_binding.dart';

// 资产管理
import './pages/other/home/ware_house/market/market_page.dart';
import './pages/other/home/ware_house/often_use_binding.dart';
// 仓库
import './pages/other/home/ware_house/recently_opened_binding.dart';
import 'pages/other/add_friend/add_friend.dart';
import 'pages/other/choice_gb/binding.dart';
import 'pages/other/choice_gb/view.dart';
import 'pages/other/choice_thing/view.dart';
import 'pages/other/file/binding.dart';
import 'pages/other/home/ware_house/ware_house.dart';
import 'pages/other/storage_location/binding.dart';
import 'pages/other/storage_location/view.dart';
import 'pages/other/thing/binding.dart';
import 'pages/other/thing/thing_details/binding.dart';
import 'pages/other/thing/thing_details/view.dart';
import 'pages/other/thing/view.dart';
import 'pages/other/ware_house/ware_house_management/application_details/binding.dart';
import 'pages/other/ware_house/ware_house_management/application_details/view.dart';
import 'pages/other/work/process_details/binding.dart';
import 'pages/other/work/process_details/view.dart';
import 'pages/other/work/work_start/binding.dart';
import 'pages/other/work/work_start/create_work/binding.dart';
import 'pages/other/work/work_start/create_work/view.dart';
import 'pages/setting/add_members/binding.dart';
import 'pages/setting/add_members/view.dart';
import 'pages/setting/cohort_info/binding.dart';
import 'pages/setting/cohort_info/view.dart';
import 'pages/setting/company_info/binding.dart';
import 'pages/setting/company_info/view.dart';
import 'pages/setting/department_info/binding.dart';
import 'pages/setting/department_info/view.dart';
import 'pages/setting/out_agency_info/binding.dart';
import 'pages/setting/out_agency_info/view.dart';
import 'pages/setting/permission_info/binding.dart';
import 'pages/setting/permission_info/view.dart';
import 'pages/setting/relationship_group/binding.dart';
import 'pages/setting/relationship_group/view.dart';
import 'pages/setting/role_settings/binding.dart';
import 'pages/setting/role_settings/view.dart';
import 'pages/setting/station_info/binding.dart';
import 'pages/setting/station_info/view.dart';

class Routers {
  // 首页
  static const String home = "/home";
  static const String todo = "/todo";
  static const String todoList = "/todoList";
  static const String todoDetail = "/todoDetail";

  // 登录
  static const String login = "/login";

  // 空间选择
  static const String spaces = "/spaces";

  // 简单表单编辑器
  static const String form = "/form";

  // 二维码扫描
  static const String scanning = "/scanning";
  static const String addFriend = "/addFriend";
  static const String scanningResult = "/scanningResult";

  // 搜索
  static const String search = "/search";
  static const String searchResult = "/searchResult";

  // 消息
  static const String messageSetting = "/messageSetting";
  static const String message = "/message";
  static const String chat = "/chat";
  static const String moreMessage = "/moreMessage";

  // 首页
  static const String index = "/index";

  // 设置
  static const String setting = "/setting";
  static const String mineUnit = "/mineUnit";
  static const String newFriends = "/newFriends";
  static const String contact = "/contact";
  static const String cohorts = "/cohorts";
  static const String uintSettings = "/uintSettings";
  static const String companyInfo = "/companyInfo";
  static const String publisher = "/publisher";
  static const String version = "/version";

  // 仓库相关
  // 资产管理
  static const String assetsManagement = "/assetsManagement";
  // 杭商城
  static const String market = "/market";

  //添加资产
  static const String addAsset = "/addAsset";

  //选择地点
  static const String storageLocation = "/storageLocation";

  //选择人员
  static const String choicePeople = "/choicePeople";

  //选择部门
  static const String choiceDepartment = "/choiceDepartment";

  //扫描二维码
  static const String qrScan = "/qrScan";

  //webView
  static const String webView = "/webView";

  //审批详情
  static const String processDetails = '/processDetails';

  //选择标准分类
  static const String choiceGb = '/choiceGb';

  //发起事项
  static const String workStart = '/workStart';

  //创建办事
  static const String createWork = '/createWork';

  //选择物
  static const String choiceThing = '/choiceThing';

  //应用详情
  static const String applicationDetails = '/applicationDetails';

  //实体列表
  static const String thing = '/thing';

  //实体详情
  static const String thingDetails = '/thingDetails';

  //文件夹
  static const String file = '/file';

  //关系列表
  static const String relationGroup = '/relationGroup';

  //内部机构详情
  static const String departmentInfo = '/departmentInfo';

  //外部机构详情
  static const String outAgencyInfo = '/outAgencyInfo';

  //岗位详情
  static const String stationInfo = '/stationInfo';

  //单位群组详情
  static const String cohortInfo = '/cohortInfo';

  //角色设置
  static const String roleSettings = '/roleSettings';

  //添加角色
  static const String addMembers = '/addMembers';
  static const String personPage = "/personPage";

  //权限标准详情
  static const String permissionInfo = "/permissionInfo";


  static String get main {
    return login;
    var user = HiveUtils.getUser();
    if (user != null) {
      return home;
    } else {
      return login;
    }
  }

  static List<GetPage> getInitRouters() {
    return [
      GetPage(
        name: Routers.login,
        page: () => const LoginPage(),
        bindings: [SettingBinding(), ChatBinding(), LoginBinding()],
      ),
      GetPage(
        name: Routers.home,
        page: () => const HomePage(),
        bindings: [
          ChatBinding(),
          HomeBinding(),
          SetHomeBinding(),
          MessageBinding(),
          IndexPageBinding(),
          WorkBinding(),
          HomeBinding(),
          SetHomeBinding(),
          MessageBinding(),
          RecentlyOpenedBinding(),
          OftenUseBinding(),
          UpdateBinding(),

        ],
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
        name: Routers.addFriend,
        page: () => AddFriendPage(),
        binding: AddFriendBinding(),
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
          UpdateBinding()
        ],
      ),
      // 资产管理
      GetPage(
        name: Routers.assetsManagement,
        page: () => const AssetsManagementPage(),
        binding: AssetsManagementBinding(),
      ),
      // 杭商城
      GetPage(
        name: Routers.market,
        page: () => const MarketPage(),
        binding: MarketBinding(),
      ),
      GetPage(
        name: Routers.storageLocation,
        page: () => StorageLocationPage(),
        binding: StorageLocationBinding(),
      ),
      GetPage(
        name: Routers.addAsset,
        page: () => AddAssetPage(),
        binding: AddAssetBinding(),
      ),
      GetPage(
        name: Routers.choicePeople,
        page: () => ChoicePeoplePage(),
        binding: ChoicePeopleBinding(),
      ),
      GetPage(
        name: Routers.choiceDepartment,
        page: () => ChoiceDepartmentPage(),
        binding: ChoiceDepartmentBinding(),
      ),
      GetPage(
        name: Routers.qrScan,
        page: () => QrScanPage(),
        binding: QrScanBinding(),
      ),
      GetPage(
        name: Routers.webView,
        page: () => WebViewPage(),
        binding: WebViewBinding(),
      ),
      GetPage(
        name: Routers.processDetails,
        page: () => ProcessDetailsPage(),
        binding: ProcessDetailsBinding(),
      ),
      GetPage(
        name: Routers.todo,
        page: () => WorkbenchPage(),
        binding: WorkBinding(),
      ),
      GetPage(
        name: Routers.todoList,
        page: () => const TodoTabPage(),
      ),
      GetPage(
        name: Routers.todoDetail,
        page: () => const TodoDetail(),
        binding: TodoDetailBinding(),
      ),
      GetPage(
        name: Routers.choiceGb,
        page: () => ChoiceGbPage(),
        binding: ChoiceGbBinding(),
      ),
      GetPage(
        name: Routers.workStart,
        page: () => WorkStartPage(),
        binding: WorkStartBinding(),
      ),
      GetPage(
        name: Routers.createWork,
        page: () => CreateWorkPage(),
        binding: CreateWorkBinding(),
      ),
      GetPage(
        name: Routers.choiceThing,
        page: () => ChoiceThingPage(),
        binding: ChoiceThingBinding(),
      ),
      GetPage(
        name: Routers.applicationDetails,
        page: () => ApplicationDetailsPage(),
        binding: ApplicationDetailsBinding(),
      ),
      GetPage(
        name: Routers.thing,
        page: () => ThingPage(),
        binding: ThingBinding(),
      ),
      GetPage(
        name: Routers.thingDetails,
        page: () => ThingDetailsPage(),
        binding: ThingDetailsBinding(),
      ),
      GetPage(
        name: Routers.file,
        page: () => FilePage(),
        binding: FileBinding(),
      ),
      GetPage(
        name: Routers.setting,
        page: () => SettingCenterPage(),
        binding: SettingCenterBinding(),
      ),
      GetPage(
        name: Routers.companyInfo,
        page: () => CompanyInfoPage(),
        binding: CompanyInfoBinding(),
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
      GetPage(
        name: Routers.relationGroup,
        page: () => RelationGroupPage(),
        binding: RelationGroupBinding(),
      ),
      GetPage(
        name: Routers.departmentInfo,
        page: () => DepartmentInfoPage(),
        binding: DepartmentInfoBinding(),
      ),
      GetPage(
        name: Routers.outAgencyInfo,
        page: () => OutAgencyInfoPage(),
        binding: OutAgencyInfoBinding(),
      ),
      GetPage(
        name: Routers.stationInfo,
        page: () => StationInfoPage(),
        binding: StationInfoBinding(),
      ),
      GetPage(
        name: Routers.cohortInfo,
        page: () => CohortInfoPage(),
        binding: CohortInfoBinding(),
      ),
      GetPage(
        name: Routers.roleSettings,
        page: () => RoleSettingsPage(),
        binding: RoleSettingsBinding(),
      ),
      GetPage(
        name: Routers.addMembers,
        page: () => AddMembersPage(),
        binding: AddMembersBinding(),
      ),
      GetPage(
        name: Routers.personPage,
        page: () => PersonPage(),
        binding: PersonBinding(),
      ),
      GetPage(
        name: Routers.permissionInfo,
        page: () => PermissionInfoPage(),
        binding: PermissionInfoBinding(),
      ),
    ];
  }
}
