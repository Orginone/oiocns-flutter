//路由 Pages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/widgets/TargetActivity/activity_comment_box.dart';
import 'package:orginone/components/widgets/TargetActivity/target_activity_view.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/wallet_controller.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/message_chat_info/binding.dart';
import 'package:orginone/pages/chat/message_chats/bindings.dart';
import 'package:orginone/pages/chat/message_chats/message_chats_list.dart';
import 'package:orginone/pages/chat/message_file.dart';
import 'package:orginone/pages/chat/message_records.dart';
import 'package:orginone/pages/chat/person_list_page.dart';
import 'package:orginone/pages/error_page/index.dart';
import 'package:orginone/pages/home/components/scan_login.dart';
import 'package:orginone/pages/home/portal/bindings.dart';
import 'package:orginone/pages/login/binding.dart';
import 'package:orginone/pages/login/forgot_password/binding.dart';
import 'package:orginone/pages/login/forgot_password/view.dart';
import 'package:orginone/pages/login/register/binding.dart';
import 'package:orginone/pages/login/register/view.dart';
import 'package:orginone/pages/login/verification_code/binding.dart';
import 'package:orginone/pages/login/verification_code/view.dart';
import 'package:orginone/pages/login/view.dart';
import 'package:orginone/pages/setting/about/binding.dart';
import 'package:orginone/pages/setting/about/view.dart';
import 'package:orginone/pages/setting/add_members/binding.dart';
import 'package:orginone/pages/setting/add_members/view.dart';
import 'package:orginone/pages/setting/attribute_info/binding.dart';
import 'package:orginone/pages/setting/attribute_info/view.dart';
import 'package:orginone/pages/setting/classification_info/binding.dart';
import 'package:orginone/pages/setting/classification_info/view.dart';
import 'package:orginone/pages/setting/cohort_info/binding.dart';
import 'package:orginone/pages/setting/cohort_info/view.dart';
import 'package:orginone/pages/setting/company_info/binding.dart';
import 'package:orginone/pages/setting/company_info/view.dart';
import 'package:orginone/pages/setting/department_info/binding.dart';
import 'package:orginone/pages/setting/department_info/view.dart';
import 'package:orginone/pages/setting/dict_info/binding.dart';
import 'package:orginone/pages/setting/home/binding.dart';
import 'package:orginone/pages/setting/home/view.dart';
import 'package:orginone/pages/setting/out_agency_info/binding.dart';
import 'package:orginone/pages/setting/out_agency_info/view.dart';
import 'package:orginone/pages/setting/permission_info/binding.dart';
import 'package:orginone/pages/setting/permission_info/view.dart';
import 'package:orginone/pages/setting/role_settings/binding.dart';
import 'package:orginone/pages/setting/role_settings/view.dart';
import 'package:orginone/pages/setting/station_info/binding.dart';
import 'package:orginone/pages/setting/station_info/view.dart';
import 'package:orginone/pages/setting/user_info/binding.dart';
import 'package:orginone/pages/setting/user_info/view.dart';
import 'package:orginone/pages/store/application_details/binding.dart';
import 'package:orginone/pages/store/application_details/view.dart';
import 'package:orginone/pages/store/bindings.dart';
import 'package:orginone/pages/store/store_tree/binding.dart';
import 'package:orginone/pages/store/store_tree/view.dart';
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
import 'package:orginone/pages/setting/bindings.dart';
import 'package:orginone/pages/setting/dict_info/view.dart';
import 'package:orginone/pages/setting/person/dynamic/bindings.dart';
import 'package:orginone/pages/setting/person/dynamic/index.dart';
import 'package:orginone/pages/setting/person/mark/bindings.dart';
import 'package:orginone/pages/setting/person/mark/view.dart';
import 'package:orginone/pages/setting/person/security/bindings.dart';
import 'package:orginone/pages/setting/person/security/index.dart';
import 'package:orginone/pages/setting/version_page.dart';
import 'package:orginone/pages/work/work_list/view.dart';
import 'package:orginone/utils/file_utils.dart';

class RoutePages {
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];
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
      page: () => VerificationCodePage(),
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
      name: Routers.home,
      page: () => const HomePage(),
      bindings: [
        HomeBinding(),
        MessageChatsControllerBinding(),
        PortalControllerBinding(),
        WorkBinding(),
        StoreBinding(),
        SettingBinding(),
        UpdateBinding(),
        WalletBinding(),
      ],
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
        name: Routers.targetActivity,
        page: () => const TargetActivityView(),
        bindings: [TargetActivityViewBinding(), ActivityCommentBoxBinding()]),
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
      page: () => WebViewPage(),
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
      page: () => UserInfoPage(),
      binding: UserInfoBinding(),
    ),
    GetPage(
      name: Routers.about,
      page: () => const AboutPage(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: Routers.storeTree,
      page: () => StoreTreePage(),
      binding: StoreTreeBinding(),
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
      page: () => VideoPlayPage(),
      binding: VideoPlayBinding(),
    ),
    GetPage(
      name: Routers.editSubGroup,
      page: () => EditSubGroupPage(),
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
      Get.toNamed(Routers.fileReader, arguments: {'file': file});
    } else if (FileUtils.isVideo(extension)) {
      Get.toNamed(Routers.videoPlay, arguments: {'file': file});
    } else {
      Get.toNamed(Routers.messageFile, arguments: {"file": file});
    }
  }
}
