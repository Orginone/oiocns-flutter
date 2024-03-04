//路由 Pages

import 'package:flutter/material.dart' hide Form;
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/modules/chat/chat_session_page.dart';
import 'package:orginone/components/modules/common/entity_info_page.dart';
import 'package:orginone/components/modules/common/file_list_page.dart';
import 'package:orginone/components/modules/common/member_list_page.dart';
import 'package:orginone/components/modules/relation/relation_cohort_page.dart';
import 'package:orginone/components/modules/relation/relation_friend_page.dart';
import 'package:orginone/components/widgets/form/form_page/index.dart';
import 'package:orginone/components/widgets/form/form_widget/form_detail/index.dart';
import 'package:orginone/components/widgets/form/form_widget/form_tool.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/controller/wallet_controller.dart';
import 'package:orginone/dart/core/chat/activity.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/thing/standard/form.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/pages/chat/message_chat_info/binding.dart';
import 'package:orginone/pages/chat/message_chats/bindings.dart';
import 'package:orginone/pages/chat/message_chats/message_chats_list.dart';
import 'package:orginone/pages/chat/message_file.dart';
import 'package:orginone/pages/chat/message_records.dart';
import 'package:orginone/pages/chat/person_list_page.dart';
import 'package:orginone/pages/error_page/index.dart';
import 'package:orginone/pages/home/components/scan_login.dart';
import 'package:orginone/pages/home/home_page.dart';
import 'package:orginone/pages/home/portal/bindings.dart';
import 'package:orginone/pages/login/binding.dart';
import 'package:orginone/pages/login/forgot_password/binding.dart';
import 'package:orginone/pages/login/forgot_password/view.dart';
import 'package:orginone/pages/login/register/binding.dart';
import 'package:orginone/pages/login/register/view.dart';
import 'package:orginone/pages/login/verification_code/binding.dart';
import 'package:orginone/pages/login/verification_code/view.dart';
import 'package:orginone/pages/login/view.dart';
import 'package:orginone/pages/relation/about/about_info/binding.dart';
import 'package:orginone/pages/relation/about/about_info/view.dart';
import 'package:orginone/pages/relation/about/binding.dart';
import 'package:orginone/pages/relation/about/version_list/binding.dart';
import 'package:orginone/pages/relation/about/version_list/view.dart';
import 'package:orginone/pages/relation/about/view.dart';
import 'package:orginone/pages/relation/add_members/binding.dart';
import 'package:orginone/pages/relation/add_members/view.dart';
import 'package:orginone/pages/relation/attribute_info/binding.dart';
import 'package:orginone/pages/relation/attribute_info/view.dart';
import 'package:orginone/pages/relation/classification_info/binding.dart';
import 'package:orginone/pages/relation/classification_info/view.dart';
import 'package:orginone/pages/relation/cohort_info/binding.dart';
import 'package:orginone/pages/relation/cohort_info/view.dart';
import 'package:orginone/pages/relation/company_info/binding.dart';
import 'package:orginone/pages/relation/company_info/view.dart';
import 'package:orginone/pages/relation/department_info/binding.dart';
import 'package:orginone/pages/relation/department_info/view.dart';
import 'package:orginone/pages/relation/dict_info/binding.dart';
import 'package:orginone/pages/relation/home/binding.dart';
import 'package:orginone/pages/relation/home/view.dart';
import 'package:orginone/pages/relation/out_agency_info/binding.dart';
import 'package:orginone/pages/relation/out_agency_info/view.dart';
import 'package:orginone/pages/relation/permission_info/binding.dart';
import 'package:orginone/pages/relation/permission_info/view.dart';
import 'package:orginone/pages/relation/relation_page.dart';
import 'package:orginone/pages/relation/role_settings/binding.dart';
import 'package:orginone/pages/relation/role_settings/view.dart';
import 'package:orginone/pages/relation/station_info/binding.dart';
import 'package:orginone/pages/relation/station_info/view.dart';
import 'package:orginone/pages/relation/user_info/binding.dart';
import 'package:orginone/pages/relation/user_info/view.dart';
import 'package:orginone/pages/store/application_details/binding.dart';
import 'package:orginone/pages/store/application_details/view.dart';
import 'package:orginone/pages/store/bindings.dart';
import 'package:orginone/pages/store/store_page.dart';
import 'package:orginone/pages/work/bindings.dart';
import 'package:orginone/pages/work/create_work/binding.dart';
import 'package:orginone/pages/work/create_work/view.dart';
import 'package:orginone/pages/work/initiate_work/binding.dart';
import 'package:orginone/pages/work/initiate_work/view.dart';
import 'package:orginone/pages/work/process_details/binding.dart';
import 'package:orginone/pages/work/process_details/view.dart';
import 'package:orginone/pages/work/work_list/binding.dart';
import 'package:orginone/utils/hive_utils.dart';
import 'package:orginone/components/modules/thing/thing_details/binding.dart';
import 'package:orginone/components/modules/thing/thing_details/view.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/pages/chat/message_chat.dart';
import 'package:orginone/pages/chat/message_chat_info/view.dart';
import 'package:orginone/pages/chat/message_receive_page/index.dart';
import 'package:orginone/pages/chat/message_routers.dart';
import 'package:orginone/pages/chat/message_setting.dart';
import 'package:orginone/pages/chat/widgets/chat_box.dart';
import 'package:orginone/pages/chat/widgets/info_item.dart';
import 'package:orginone/pages/home/home/binding.dart';
import 'package:orginone/pages/home/home/view.dart';
import 'package:orginone/pages/login/login_transition/view.dart';
import 'package:orginone/pages/relation/bindings.dart';
import 'package:orginone/pages/relation/dict_info/view.dart';
import 'package:orginone/pages/relation/person/dynamic/bindings.dart';
import 'package:orginone/pages/relation/person/dynamic/index.dart';
import 'package:orginone/pages/relation/person/mark/bindings.dart';
import 'package:orginone/pages/relation/person/mark/view.dart';
import 'package:orginone/pages/relation/person/security/bindings.dart';
import 'package:orginone/pages/relation/person/security/index.dart';
import 'package:orginone/pages/relation/version/version_page.dart';
import 'package:orginone/pages/work/work_list/view.dart';
import 'package:orginone/utils/index.dart';

import '../../pages/store/store_tree/index.dart';

class RoutePages {
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];
  static List<Route<dynamic>> historyRoute = [];
  static String get main {
    var user = HiveUtils.getUser();
    if (user != null) {
      return Routers.home;
    } else {
      return Routers.login;
    }
  }

  //列表
  static List<GetPage> getInitRouters = [
    GetPage(
      name: Routers.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routers.verificationCode,
      page: () => const VerificationCodePage(),
      binding: VerificationCodeBinding(),
    ),
    GetPage(
        name: Routers.register,
        page: () => const RegisterPage(),
        binding: RegisterBinding()),
    GetPage(
      name: Routers.forgotPassword,
      page: () => const ForgotPasswordPage(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: Routers.logintrans,
      page: () => const LoginTransPage(),
    ),
    GetPage(
      name: Routers.homeOld,
      page: () => HomePageOld(),
      bindings: [
        HomeBinding(),
        MessageChatsControllerBinding(),
        PortalControllerBinding(),
        WorkBinding(),
        StoreBinding(),
        RelationBinding(),
        UpdateBinding(),
        WalletBinding(),
      ],
    ),

    /// 首页
    GetPage(name: Routers.home, page: () => HomePage()),

    /// 数据页面
    GetPage(name: Routers.storePage, page: () => const StorePage()),

    /// 关系页面
    GetPage(name: Routers.relation, page: () => const RelationPage()),

    /// 关系>好友
    GetPage(
      name: Routers.relationFriend,
      page: () => RelationFriendPage(),
      binding: VideoPlayBinding(),
    ),

    /// 关系>群组
    GetPage(name: Routers.relationCohort, page: () => RelationCohortPage()),

    /// 实体详情
    GetPage(name: Routers.entityInfo, page: () => EntityInfoPage()),

    /// 好友成员列表
    GetPage(name: Routers.memberList, page: () => MemberListPage()),

    /// 文件目录列表
    GetPage(name: Routers.fileList, page: () => FileListPage()),

    ///动态详情
    GetPage(
      name: Routers.targetActivity,
      page: () => TargetActivityList(),
    ),

    /// 沟通会话页面
    GetPage(
      name: Routers.chatSession,
      page: () => ChatSessionPage(),
      binding: VideoPlayBinding(),
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
      page: () => const MessageChatPage(),
      bindings: [PlayBinding(), ChatBoxBinding(), MessageChatBinding()],
    ),
    GetPage(
      name: Routers.messageReceive,
      page: () => const MessageReceivePage(),
    ),
    GetPage(
        name: Routers.targetActivityOld,
        page: () => const TargetActivityView(),
        bindings: [TargetActivityViewBinding(), ActivityCommentBoxBinding()]),
    GetPage(
      name: Routers.storageLocation,
      page: () => const StorageLocationPage(),
      binding: StorageLocationBinding(),
    ),
    GetPage(
      name: Routers.addAsset,
      page: () => const AddAssetPage(),
      binding: AddAssetBinding(),
    ),
    GetPage(
      name: Routers.qrScan,
      page: () => const QrScanPage(),
      binding: QrScanBinding(),
    ),
    GetPage(
      name: Routers.scanLogin,
      page: () => ScanLoginPage(),
    ),
    GetPage(
      name: Routers.webView,
      page: () => const WebViewPage(),
      binding: WebViewBinding(),
    ),
    GetPage(
      name: Routers.processDetails,
      page: () => const ProcessDetailsPage(),
      binding: ProcessDetailsBinding(),
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
      name: Routers.createWork,
      page: () => const CreateWorkPage(),
      binding: CreateWorkBinding(),
    ),
    GetPage(
      name: Routers.choiceThing,
      page: () => ChoiceThingPage(),
      binding: ChoiceThingBinding(),
    ),
    GetPage(
      name: Routers.applicationDetails,
      page: () => const ApplicationDetailsPage(),
      binding: ApplicationDetailsBinding(),
    ),
    GetPage(
      name: Routers.thing,
      page: () => ThingPage(),
      binding: ThingBinding(),
    ),
    GetPage(
      name: Routers.thingDetails,
      page: () => const ThingDetailsPage(),
      binding: ThingDetailsBinding(),
    ),
    GetPage(
      name: Routers.relationCenter,
      page: () => RelationCenterPage(),
      binding: RelationCenterBinding(),
    ),
    GetPage(
      name: Routers.companyInfo,
      page: () => const CompanyInfoPage(),
      binding: CompanyInfoBinding(),
    ),
    GetPage(
      name: Routers.version,
      page: () => const VersionPage(),
      binding: VersionBinding(),
    ),
    GetPage(
      name: Routers.departmentInfo,
      page: () => const DepartmentInfoPage(),
      binding: DepartmentInfoBinding(),
    ),
    GetPage(
      name: Routers.outAgencyInfo,
      page: () => const OutAgencyInfoPage(),
      binding: OutAgencyInfoBinding(),
    ),
    GetPage(
      name: Routers.stationInfo,
      page: () => const StationInfoPage(),
      binding: StationInfoBinding(),
    ),
    GetPage(
      name: Routers.cohortInfo,
      page: () => const CohortInfoPage(),
      binding: CohortInfoBinding(),
    ),
    GetPage(
      name: Routers.roleSettings,
      page: () => const RoleSettingsPage(),
      binding: RoleSettingsBinding(),
    ),
    GetPage(
      name: Routers.addMembers,
      page: () => const AddMembersPage(),
      binding: AddMembersBinding(),
    ),
    GetPage(
      name: Routers.permissionInfo,
      page: () => const PermissionInfoPage(),
      binding: PermissionInfoBinding(),
    ),
    GetPage(
      name: Routers.classificationInfo,
      page: () => const ClassificationInfoPage(),
      binding: ClassificationInfoBinding(),
    ),
    GetPage(
      name: Routers.mark,
      page: () => const MarkPage(),
      binding: MarkBinding(),
    ),
    GetPage(
      name: Routers.dynamic,
      page: () => const DynamicPage(),
      binding: DynamicBinding(),
    ),
    GetPage(
      name: Routers.security,
      page: () => const SecurityPage(),
      binding: SecurityBinding(),
    ),
    GetPage(
      name: Routers.cardbag,
      page: () => const CardbagPage(),
      binding: CardbagBinding(),
    ),
    GetPage(
      name: Routers.userInfo,
      page: () => const UserInfoPage(),
      binding: UserInfoBinding(),
    ),
    GetPage(
      name: Routers.about,
      page: () => AboutPage(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: Routers.originone,
      page: () => const VersionInfoPage(),
      binding: VersionInfoBinding(),
    ),
    GetPage(
      name: Routers.versionList,
      page: () => const VersionListPage(),
      binding: VersionListBinding(),
    ),
    GetPage(
      name: Routers.storeTree,
      page: () => StoreTreePage(),
      binding: StoreTreeBinding(),
    ),
    GetPage(
      name: Routers.dictInfo,
      page: () => const DictInfoPage(),
      binding: DictInfoBinding(),
    ),
    GetPage(
      name: Routers.attributeInfo,
      page: () => const AttributeInfoPage(),
      binding: AttributeInfoBinding(),
    ),
    GetPage(
      name: Routers.workList,
      page: () => WorkListPage(),
      binding: WorkListBinding(),
    ),
    GetPage(
        name: Routers.messageFile,
        page: () => const MessageFilePage(),
        binding: MessageFileBinding()),
    GetPage(
      name: Routers.messageRecords,
      page: () => const MessageRecordsPage(),
      binding: MessageRecordsBinding(),
    ),
    GetPage(
      name: Routers.personListPage,
      page: () => const PersonListPage(),
    ),
    GetPage(
      name: Routers.pdfReader,
      page: () => const PDFReaderPage(),
    ),
    GetPage(
      name: Routers.shareQrCode,
      page: () => const ShareQrCodePage(),
      binding: ShareQrCodeBinding(),
    ),
    GetPage(
      name: Routers.photoView,
      page: () => const PhotoViewPage(),
      binding: PhotoViewBinding(),
    ),
    GetPage(
      name: Routers.fileReader,
      page: () => const FileReaderPage(),
      binding: FileReaderBinding(),
    ),
    GetPage(
      name: Routers.generalBreadCrumbs,
      page: () => GeneralBreadCrumbsPage(),
      binding: GeneralBreadCrumbsBinding(),
    ),
    GetPage(
      name: Routers.videoPlay,
      page: () => const VideoPlayPage(),
      binding: VideoPlayBinding(),
    ),
    GetPage(
      name: Routers.editSubGroup,
      page: () => const EditSubGroupPage(),
      binding: EditSubGroupBinding(),
    ),
    GetPage(
      name: Routers.messageChatInfo,
      page: () => const MessageChatInfoPage(),
      binding: MessageChatInfoBinding(),
    ),
    GetPage(
      name: Routers.createBag,
      page: () => const CreateBagPage(),
      binding: CreateBagBinding(),
    ),
    GetPage(
      name: Routers.guideBag,
      page: () => const GuideBagPage(),
    ),
    GetPage(
      name: Routers.importWallet,
      page: () => const ImportWalletPage(),
    ),
    GetPage(
      name: Routers.bagDetails,
      page: () => const BagDetailsPage(),
    ),
    GetPage(
      name: Routers.walletDetails,
      page: () => const WalletDetailsPage(),
      binding: WalletDetailsBinding(),
    ),
    GetPage(
      name: Routers.transferAccounts,
      page: () => const TransferAccounts(),
    ),
    GetPage(
      name: Routers.searchCoin,
      page: () => const SearchCoinPage(),
      binding: SearchCoinBinding(),
    ),
    GetPage(
      name: Routers.formDetail,
      page: () => const FormDetailPage(),
    ),
    GetPage(
      name: Routers.formPage,
      page: () => const FormPage(),
    ),
    GetPage(
      name: Routers.errorPage,
      page: () => const ErrorPage(),
    ),
  ];
  static void jumpCreateBag() {
    changeTransition(Transition.downToUp);
    Get.toNamed(Routers.createBag)?.then((value) => changeTransition());
  }

  static void jumpImportWallet() {
    changeTransition(Transition.downToUp);
    Get.toNamed(Routers.importWallet)?.then((value) => changeTransition());
  }

  static void jumpCardBag() {
    if (walletCtrl.wallet.isEmpty) {
      changeTransition(Transition.downToUp);
      Get.toNamed(Routers.guideBag);
      return;
    }
    Get.toNamed(Routers.cardbag);
  }

  static void changeTransition([Transition? transition]) {
    Get.config(
      enableLog: Get.isLogEnable,
      defaultTransition: transition ?? Transition.native,
      defaultOpaqueRoute: Get.isOpaqueRouteDefault,
      defaultPopGesture: Get.isPopGestureEnable,
      defaultDurationTransition: Get.defaultTransitionDuration,
    );
  }

  static void jumpFile({required FileItemShare file, String type = 'chat'}) {
    var extension = file.extension?.toLowerCase() ?? "";
    //TODO:react分支 无此方法  具体调试看这个业务是什么
    // if (type == "store") {
    //   settingCtrl.store.onRecordRecent(RecentlyUseModel(
    //       type: StoreEnum.file.label,
    //       file: FileItemModel.fromJson(file.toJson())));
    // }
    if (FileUtils.isPdf(extension)) {
      Get.toNamed(Routers.pdfReader, arguments: {"file": file});
    } else if (FileUtils.isImage(extension)) {
      Get.toNamed(Routers.photoView, arguments: {
        "images": file.shareLink != null && file.shareLink!.contains('http')
            ? [file.shareLink!]
            : ['${Constant.host}${file.shareLink}']
      });
    } else if (FileUtils.isWord(extension)) {
      // TODO 临时处理方案，让其可以下载通过第三方软件查看
      // Get.toNamed(Routers.fileReader, arguments: {'file': file});
      Get.toNamed(Routers.messageFile, arguments: {'file': file});
    } else if (FileUtils.isVideo(extension)) {
      Get.toNamed(Routers.videoPlay, arguments: {'file': file});
    } else {
      Get.toNamed(Routers.messageFile, arguments: {"file": file});
    }
  }

  /// 跳转到数据二级页面
  static void jumpStore({dynamic parentData, List? listDatas}) async {
    if (parentData.typeName == SpaceEnum.form.label) {
      // Get.toNamed(Routers.thing,
      //     arguments: {'form': parentData, "belongId": parentData.belongId});
      Form form = parentData;
      await form.loadContent();
      XForm xForm = parentData.metadata;
      xForm.fields = form.fields;
      // element.data = getFormData(element.id);
      for (var field in xForm.fields) {
        field.field = await FormTool.initFields(field);
      }
      Get.toNamed(Routers.formPage, arguments: {
        'title': parentData.name,
        'mainForm': [xForm].cast<XForm>(),
        "subForm": [],
      });
      //跳转办事详情
      // Get.toNamed(Routers.processDetails, arguments: {"todo": parentData});
      LogUtil.d(parentData);
      LogUtil.d(parentData.metadata);
    } else {
      jumpHome(
          home: HomeEnum.store, parentData: parentData, listDatas: listDatas);
    }
  }

  /// 跳转到数据详情页面
  /// data 需要展示的目标对象
  /// defaultActiveTabs 默认激活页签
  static void jumpStoreInfoPage(
      {dynamic data, List<String> defaultActiveTabs = const []}) {
    LogUtil.d('jumpStoreInfoPage');
    LogUtil.d(data.runtimeType);
    LogUtil.d(data);
    // if (data.typeName == TargetType.person.label) {
    //   Get.toNamed(Routers.storage, arguments: {
    //     "parents": [..._getParentRouteParams(), data],
    //     "defaultActiveTabs": defaultActiveTabs,
    //     "datas": data
    //   });
    // } else if (data.typeName == TargetType.cohort.label) {
    //   Get.toNamed(Routers.storage, arguments: {
    //     "parents": [..._getParentRouteParams(), data],
    //     "defaultActiveTabs": defaultActiveTabs,
    //     "datas": data
    //   });
    // }
  }

  /// 跳转到关系二级页面
  static void jumpRelation({dynamic parentData, List? listDatas}) {
    jumpHome(
        home: HomeEnum.relation, parentData: parentData, listDatas: listDatas);
  }

  /// 跳转到关系详情页面
  /// data 需要展示的目标对象
  /// defaultActiveTabs 默认激活页签
  static void jumpRelationInfo(
      {dynamic data, List<String>? defaultActiveTabs}) {
    if (data.typeName == TargetType.person.label) {
      Get.toNamed(Routers.relationFriend,
          arguments: RouterParam(
              parents: [..._getParentRouteParams(), RouterParam(datas: data)],
              defaultActiveTabs: defaultActiveTabs ?? ["设置"],
              datas: data));
      // {
      //   "parents": [..._getParentRouteParams(), data],
      //   "defaultActiveTabs": defaultActiveTabs ?? [TargetType.person.label],
      //   "datas": data
      // }
    } else if (data.typeName == SpaceEnum.property.label) {
    } else {
      // if (data.typeName == TargetType.cohort.label)
      Get.toNamed(Routers.relationCohort,
          arguments: RouterParam(
              parents: [..._getParentRouteParams(), RouterParam(datas: data)],
              defaultActiveTabs: defaultActiveTabs ?? ["设置"],
              datas: data));
      // {
      //   "parents": [..._getParentRouteParams(), data],
      //   "defaultActiveTabs": defaultActiveTabs ?? [SpaceEnum.member.label],
      //   "datas": data
      // }
    }
  }

  /// 跳转到关系详情页面
  /// data 需要展示的目标对象
  /// defaultActiveTabs 默认激活页签
  static void jumpRelationMember(
      {dynamic data, List<String>? defaultActiveTabs}) {
    if (data.typeName == TargetType.person.label) {
      Get.toNamed(Routers.relationFriend,
          arguments: RouterParam(
              parents: [..._getParentRouteParams(), RouterParam(datas: data)],
              defaultActiveTabs: defaultActiveTabs ?? [TargetType.person.label],
              datas: data));
      // {
      //   "parents": [..._getParentRouteParams(), data],
      //   "defaultActiveTabs": defaultActiveTabs ?? [TargetType.person.label],
      //   "datas": data
      // }
    } else if (data.typeName != TargetType.storage.label) {
      // if (data.typeName == TargetType.cohort.label)
      Get.toNamed(Routers.relationCohort,
          arguments: RouterParam(
              parents: [..._getParentRouteParams(), RouterParam(datas: data)],
              defaultActiveTabs: defaultActiveTabs ?? [SpaceEnum.member.label],
              datas: data));
      // {
      //   "parents": [..._getParentRouteParams(), data],
      //   "defaultActiveTabs": defaultActiveTabs ?? [SpaceEnum.member.label],
      //   "datas": data
      // }
    }
  }

  /// 好友/成员列表
  static void jumpMemberList<T>({required T data}) {
    Get.toNamed(Routers.memberList,
        arguments: RouterParam(
            parents: [..._getParentRouteParams(), RouterParam(datas: data)],
            datas: data));
    // {
    //   "parents": [..._getParentRouteParams(), data],
    //   "defaultActiveTabs": [],
    //   "datas": data
    // }
  }

  /// 跳转到实体详情页面
  static void jumpEneityInfo<T>({required T data}) {
    Get.toNamed(Routers.entityInfo,
        arguments: RouterParam(
            parents: [..._getParentRouteParams(), RouterParam(datas: data)],
            datas: data));
    // {
    //   "parents": [..._getParentRouteParams(), data],
    //   "defaultActiveTabs": [],
    //   "datas": data
    // }
  }

  /// 跳转到文件目录列表页面
  static void jumpFileList<T>({required T data}) {
    Get.toNamed(Routers.fileList,
        preventDuplicates: false,
        arguments: RouterParam(
            parents: [..._getParentRouteParams(), RouterParam(datas: data)],
            datas: data));
  }

  /// 跳转到消息模块
  static void jumpChat({List<String> defaultActiveTabs = const []}) {
    jumpHome(home: HomeEnum.chat, defaultActiveTabs: defaultActiveTabs);
  }

  /// 跳转到办事模块
  static void jumpWork({List<String> defaultActiveTabs = const []}) {
    jumpHome(home: HomeEnum.work, defaultActiveTabs: defaultActiveTabs);
  }

  /// 跳转到首页
  static void jumpHome(
      {required HomeEnum home,
      dynamic parentData,
      List? listDatas,
      List<String> defaultActiveTabs = const [],
      bool preventDuplicates = false}) {
    if (relationCtrl.homeEnum.value != home) {
      relationCtrl.setHomeEnum(home);
      Get.offAndToNamed(Routers.home,
          arguments: RouterParam(
              modelName: home.label,
              parents: [
                ..._getParentRouteParams(),
                if (null != parentData) RouterParam(datas: parentData)
              ],
              datas: listDatas,
              defaultActiveTabs: defaultActiveTabs));
    } else {
      Get.toNamed(Routers.home,
          preventDuplicates: preventDuplicates,
          arguments: RouterParam(
              modelName: home.label,
              parents: [
                ..._getParentRouteParams(),
                if (null != parentData) RouterParam(datas: parentData)
              ],
              datas: listDatas,
              defaultActiveTabs: defaultActiveTabs));
    }
  }

  static void jumpChatSession({required ISession data}) {
    jumpRelationMember(data: data, defaultActiveTabs: ["沟通"]);
  }

  /// 跳转到办事详情
  static Future<void> jumpWorkInfo<T extends IWorkTask>(
      {required T work}) async {
    if (work.targets.isEmpty) {
      //加载流程实例数据
      await work.loadInstance();
    }
    //跳转办事详情
    Get.toNamed(Routers.processDetails, arguments: {
      "todo": work,
    });
  }

  ///跳转动态详情
  static void jumpActivityInfo(IActivityMessage data) {
    Get.toNamed(Routers.targetActivity,
        arguments: RouterParam(
          parents: [..._getParentRouteParams(), RouterParam(datas: data)],
          datas: data,
        ));
  }

  /// 获取关系子页面参数
  static List<RouterParam> _getParentRouteParams() {
    var params = Get.arguments;
    if (isValidParams()) {
      if (params is RouterParam) {
        return params.parents;
      } else if (params is Map) {
        return params["parents"];
      }
    }
    return [];
  }

  /// 获取关系子页面参数
  static String? getRouteTitle() {
    var params = Get.arguments;
    if (isValidParams()) {
      if (params is RouterParam) {
        return params.parents.map((e) => e.datas.name).join("/");
      } else if (params is Map) {
        return params["parents"].map((e) => e.name).join("/");
      }
    }
    return null;
  }

  /// 获取关系子页面参数
  static List<String>? getRouteDefaultActiveTab() {
    var params = Get.arguments;
    // if (isValidParams()) {
    if (params is RouterParam) {
      return params.defaultActiveTabs;
    } else if (params is Map) {
      return params["defaultActiveTabs"];
    }
    // }
    return null;
  }

  /// 获取关系子页面参数
  static dynamic getParentRouteParam() {
    var params = Get.arguments;

    if (isValidParams()) {
      if (params is RouterParam) {
        return params.parents.isNotEmpty ? params.parents.last.datas : null;
      } else if (params is Map) {
        return params["parents"].isNotEmpty
            ? params["parents"].last['datas']
            : null;
      }
    }
    return;
  }

  /// 获取关系子页面参数
  static dynamic getRootRouteParam() {
    var params = Get.arguments;

    if (isValidParams()) {
      if (params is RouterParam) {
        return params.parents.first.datas;
      } else if (params is Map) {
        return params["parents"].first.datas;
      }
    }
    return;
  }

  /// 路由层级
  static int getRouteLevel() {
    // var params = Get.arguments;
    // if (isValidParams()) {
    //   if (params is RouterParam) {
    //     return params.parents.length;
    //   } else if (params is Map) {
    //     return params["parents"].length;
    //   }
    // }
    // return Get.currentRoute == Routers.home ? 0 : 1;
    return RoutePages.history.length - 1;
  }

  /// 获取关系子页面参数
  static dynamic getRouteParams({HomeEnum? homeEnum}) {
    var params = Get.arguments;
    if (isValidParams(homeEnum: homeEnum) && getRouteLevel() > 0) {
      if (params is RouterParam) {
        return params.datas;
      } else if (params is Map) {
        return params["datas"];
      }
    }
    return;
  }

  static bool isValidParams({HomeEnum? homeEnum}) {
    var params = Get.arguments;
    if (params is RouterParam) {
      return null == homeEnum
          ? true
          : homeEnum == relationCtrl.homeEnum.value
              ? getRouteLevel() > 0
              : false;
    } else if (params is Map) {
      return params["parents"]?.firstOrNull?['modelName'] ==
          relationCtrl.homeEnum.value.label;
    }
    return false;
  }

  // static bool isClearParams = false;
  static void clearRoute() {
    print('>>>>>>>>> 1>${Get.routeTree.routes}');
    debugPrint('did ${RoutePages.history.toString()}');
    if (RoutePages.history.length <= 1) return;
    RoutePages.historyRoute.sublist(1).map((e) {
      // observer.didRemove(e, null);
      Get.removeRoute(e);
      e.didPop(e);
    });
    RoutePages.history.removeRange(1, RoutePages.history.length);
    RoutePages.historyRoute.removeRange(1, RoutePages.historyRoute.length);
    debugPrint('did ${RoutePages.history.toString()}');
    // Get.routeTree.routes.removeRange(1, Get.routeTree.routes.length);
    print('>>>>>>>>> 2>${Get.routeTree.routes}');
    // isClearParams = true;
    // Get.toNamed(Routers.home, preventDuplicates: false);
    // Get.closeCurrentSnackbar();
  }
}

/// 路由参数
class RouterParam {
  /// 模块名称
  late String modelName;

  /// 上级路由参数
  List<RouterParam> parents;

  /// 默认激活页签
  List<String> defaultActiveTabs;

  /// 路由穿参
  dynamic datas;

  RouterParam(
      {String? modelName,
      this.parents = const [],
      this.defaultActiveTabs = const [],
      this.datas}) {
    this.modelName = modelName ?? relationCtrl.homeEnum.value.label;
  }
}
