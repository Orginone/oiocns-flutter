import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/pages/chat/message_chat.dart';
import 'package:orginone/pages/chat/message_setting.dart';
import 'package:orginone/pages/chat/message_routers.dart';
import 'package:orginone/pages/chat/widgets/chat_box.dart';
import 'package:orginone/pages/chat/widgets/info_item.dart';
import 'package:orginone/pages/login/binding.dart';
import 'package:orginone/pages/login/view.dart';
import 'package:orginone/pages/market/market_tree/view.dart';
import 'package:orginone/pages/other/add_asset/binding.dart';
import 'package:orginone/pages/other/add_asset/view.dart';
import 'package:orginone/pages/other/choice_department/binding.dart';
import 'package:orginone/pages/other/choice_department/view.dart';
import 'package:orginone/pages/other/choice_people/binding.dart';
import 'package:orginone/pages/other/choice_people/view.dart';
import 'package:orginone/pages/other/choice_thing/binding.dart';
import 'package:orginone/pages/other/file/view.dart';
import 'package:orginone/pages/home/home_page.dart';
import 'package:orginone/pages/other/qr_scan/binding.dart';
import 'package:orginone/pages/other/qr_scan/view.dart';
import 'package:orginone/pages/other/scanning/scanning_page.dart';
import 'package:orginone/pages/other/scanning/scanning_result_pge.dart';
import 'package:orginone/pages/other/search_page.dart';
import 'package:orginone/pages/other/web_view/binding.dart';
import 'package:orginone/pages/other/web_view/view.dart';
import 'package:orginone/pages/work/work_list/view.dart';
import 'package:orginone/pages/work/work_start/view.dart';
import 'package:orginone/pages/setting/dict_info/view.dart';
import 'package:orginone/pages/setting/home/binding.dart';
import 'package:orginone/pages/setting/home/view.dart';
import 'package:orginone/pages/setting/person/cardbag/bindings.dart';
import 'package:orginone/pages/setting/person/cardbag/index.dart';
import 'package:orginone/pages/setting/person/dynamic/bindings.dart';
import 'package:orginone/pages/setting/person/dynamic/index.dart';
import 'package:orginone/pages/setting/person/mark/bindings.dart';
import 'package:orginone/pages/setting/person/mark/view.dart';
import 'package:orginone/pages/setting/person/security/bindings.dart';
import 'package:orginone/pages/setting/person/security/index.dart';
import 'package:orginone/pages/setting/person/view.dart';
import 'package:orginone/pages/setting/version_page.dart';

// 资产管理
// 资产管理
// 仓库
import 'pages/chat/message_chats.dart';
import 'pages/chat/message_file.dart';
import 'pages/chat/message_records.dart';
import 'pages/home/index/index_page.dart';
import 'pages/login/forgot_password/binding.dart';
import 'pages/login/forgot_password/view.dart';
import 'pages/login/register/binding.dart';
import 'pages/login/register/view.dart';
import 'pages/login/verification_code/binding.dart';
import 'pages/login/verification_code/view.dart';
import 'pages/market/market_tree/binding.dart';
import 'pages/other/add_friend/add_friend.dart';
import 'pages/other/choice_gb/binding.dart';
import 'pages/other/choice_gb/view.dart';
import 'pages/other/choice_thing/view.dart';
import 'pages/other/file/binding.dart';
import 'pages/other/storage_location/binding.dart';
import 'pages/other/storage_location/view.dart';
import 'pages/other/thing/binding.dart';
import 'pages/other/thing/thing_details/binding.dart';
import 'pages/other/thing/thing_details/view.dart';
import 'pages/other/thing/view.dart';
import 'pages/store/application_details/binding.dart';
import 'pages/store/application_details/view.dart';
import 'pages/store/store_tree/binding.dart';
import 'pages/store/store_tree/view.dart';
import 'pages/work/initiate_work/binding.dart';
import 'pages/work/initiate_work/view.dart';
import 'pages/work/process_details/binding.dart';
import 'pages/work/process_details/view.dart';
import 'pages/work/work_list/binding.dart';
import 'pages/work/work_start/binding.dart';
import 'pages/work/work_start/create_work/binding.dart';
import 'pages/work/work_start/create_work/view.dart';
import 'pages/setting/add_members/binding.dart';
import 'pages/setting/add_members/view.dart';
import 'pages/setting/attribute_info/binding.dart';
import 'pages/setting/attribute_info/view.dart';
import 'pages/setting/classification_info/binding.dart';
import 'pages/setting/classification_info/view.dart';
import 'pages/setting/cohort_info/binding.dart';
import 'pages/setting/cohort_info/view.dart';
import 'pages/setting/company_info/binding.dart';
import 'pages/setting/company_info/view.dart';
import 'pages/setting/department_info/binding.dart';
import 'pages/setting/department_info/view.dart';
import 'pages/setting/dict_info/binding.dart';
import 'pages/setting/out_agency_info/binding.dart';
import 'pages/setting/out_agency_info/view.dart';
import 'pages/setting/permission_info/binding.dart';
import 'pages/setting/permission_info/view.dart';
import 'pages/setting/role_settings/binding.dart';
import 'pages/setting/role_settings/view.dart';
import 'pages/setting/station_info/binding.dart';
import 'pages/setting/station_info/view.dart';
import 'pages/setting/user_info/binding.dart';
import 'pages/setting/user_info/view.dart';

class Routers {
  // 首页
  static const String home = "/home";
  static const String todo = "/todo";
  static const String todoList = "/todoList";
  static const String todoDetail = "/todoDetail";

  // 登录
  static const String login = "/login";

  //验证码
  static const String verificationCode = "/verificationCode";

  //注册
  static const String register = "/register";

  //忘记密码
  static const String forgotPassword = "/forgotPassword";

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
  static const String messageChat = "/messageChat";
  static const String messageChatsList = "/messageChatsList";

  // 首页
  static const String index = "/index";

  // 设置
  static const String settingCenter = "/settingCenter";
  static const String companyInfo = "/companyInfo";
  static const String version = "/version";
  static const String userInfo = "/userInfo";

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

  //选择资产分类
  static const String choiceAssets = "/choiceAssets";
  static const String choiceSpecificAssets = "/choiceSpecificAssets";

  //资产详情
  static const String assetsDetails = "/assetsDetails";

  //创建盘点
  static const String createClaim = "/createClaim";

  //创建移交
  static const String createTransfer = "/createTransfer";

  //创建申购
  static const String createDispose = "/createDispose";

  //创建交回
  static const String createHandOver = "/createHandOver";

  //资产盘点
  static const String assetsCheck = "/assetsCheck";

  //资产模块通用详情
  static const String generalDetails = "/generalDetails";

  //审批单据
  static const String approveDocuments = "/approveDocuments";

  //资产模块功能页
  static const String centerFunction = "/centerFunction";

//批量移除资产
  static const String bulkRemovalAsset = "/bulkRemovalAsset";

  //批量操作资产
  static const String batchOperationAsset = "/batchOperationAsset";

  //扫描二维码
  static const String qrScan = "/qrScan";

  //webView
  static const String webView = "/webView";

  //审批详情
  static const String processDetails = '/processDetails';

  //选择标准分类
  static const String choiceGb = '/choiceGb';

  //发起会话
  static const String initiateChat = '/initiateChat';

  //发起办事
  static const String initiateWork = '/initiateWork';

  //事项
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

  //个人中心
  static const String personPage = "/personPage";

  static const String cardbag = "/cardbag";
  static const String dynamic = "/dynamic";
  static const String mark = "/mark";
  static const String security = "/security";

  //权限标准详情
  static const String permissionInfo = "/permissionInfo";

  //分类标准详情
  static const String classificationInfo = "/classificationInfo";

  //字段定义详情
  static const String dictInfo = "/dictInfo";

  //属性定义详情
  static const String attributeInfo = "/attributeInfo";

  //属性定义详情
  static const String workList = "/workList";

  static const String storeTree = "/storeTree";

  static const String marketTree = "/marketTree";

  static const String messageFile = "/messageFile";

  static const String messageRecords = "/messageRecords";

  static String get main {
    return login;
    // var user = HiveUtils.getUser();
    // if (user != null) {
    //   return home;
    // } else {
    //   return login;
    // }
  }

  static List<GetPage> getInitRouters() {
    return [
      GetPage(
        name: Routers.login,
        page: () => LoginPage(),
        binding: LoginBinding(),
      ),
      GetPage(
        name: Routers.verificationCode,
        page: () => VerificationCodePage(),
        binding: VerificationCodeBinding(),
      ),
      GetPage(
          name: Routers.register,
          page: () => RegisterPage(),
          binding: RegisterBinding()),
      GetPage(
        name: Routers.forgotPassword,
        page: () => ForgotPasswordPage(),
        binding: ForgotPasswordBinding(),
      ),
      GetPage(
        name: Routers.home,
        page: () => const HomePage(),
        bindings: [
          HomeBinding(),
          IndexPageBinding(),
          UpdateBinding(),
          ClassificationInfoBinding()
        ],
      ),
      GetPage(
        name: Routers.scanning,
        page: () => const ScanningPage(),
        binding: ScanningBinding(),
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
        name: Routers.messageSetting,
        page: () => const MessageSetting(),
      ),
      GetPage(
        name: Routers.messageChatsList,
        page: () => const MessageChatsList(),
        bindings: [MessageChatsListBinding()],
      ),
      GetPage(
        name: Routers.messageChat,
        page: () => MessageChatPage(),
        bindings: [PlayBinding(),ChatBoxBinding(),MessageChatBinding()],
      ),
      GetPage(
        name: Routers.addFriend,
        page: () => AddFriendPage(),
        binding: AddFriendBinding(),
      ),
      GetPage(
        name: Routers.index,
        page: () => IndexPage(),
        bindings: [
          HomeBinding(),
          IndexPageBinding(),
          UpdateBinding(),
          // SettingCenterBinding(),
          SettingBinding(),
          ClassificationInfoBinding(),
          PermissionInfoBinding(),
          HomeBinding(),
        ],
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
        name: Routers.choiceGb,
        page: () => ChoiceGbPage(),
        binding: ChoiceGbBinding(),
      ),
      GetPage(
        name: Routers.initiateChat,
        page: () => MessageRouters(),
        binding: MessagesBinding(),
      ),
      GetPage(
        name: Routers.initiateWork,
        page: () => InitiateWorkPage(),
        binding: InitiateWorkBinding(),
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
        name: Routers.settingCenter,
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
      GetPage(
        name: Routers.classificationInfo,
        page: () => ClassificationInfoPage(),
        binding: ClassificationInfoBinding(),
      ),
      GetPage(
        name: Routers.mark,
        page: () => MarkPage(),
        binding: MarkBinding(),
      ),
      GetPage(
        name: Routers.dynamic,
        page: () => DynamicPage(),
        binding: DynamicBinding(),
      ),
      GetPage(
        name: Routers.security,
        page: () => SecurityPage(),
        binding: SecurityBinding(),
      ),
      GetPage(
        name: Routers.cardbag,
        page: () => CardbagPage(),
        binding: CardbagBinding(),
      ),
      GetPage(
        name: Routers.userInfo,
        page: () => UserInfoPage(),
        binding: UserInfoBinding(),
      ),
      GetPage(
        name: Routers.storeTree,
        page: () => StoreTreePage(),
        binding: StoreTreeBinding(),
      ),
      GetPage(
        name: Routers.marketTree,
        page: () => MarketTreePage(),
        binding: MarketTreeBinding(),
      ),
      GetPage(
        name: Routers.dictInfo,
        page: () => DictInfoPage(),
        binding: DictInfoBinding(),
      ),
      GetPage(
        name: Routers.attributeInfo,
        page: () => AttributeInfoPage(),
        binding: AttributeInfoBinding(),
      ),
      GetPage(
        name: Routers.workList,
        page: () => WorkListPage(),
        binding: WorkListBinding(),
      ),
      GetPage(
        name: Routers.messageFile,
        page: () => const MessageFile(),
      ),
      GetPage(
        name: Routers.messageRecords,
        page: () =>  MessageRecordsPage(),
        binding: MessageRecordsBinding(),
      ),
    ];
  }
}
