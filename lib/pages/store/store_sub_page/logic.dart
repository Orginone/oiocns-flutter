import 'dart:convert';

import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/store/state.dart';
import 'package:orginone/pages/store/store_tree/state.dart';

import '../config.dart';
import 'state.dart';

class StoreSubController extends BaseListController<StoreSubState> {
  @override
  final StoreSubState state = StoreSubState();

  late String type;

  StoreSubController(this.type);

  @override
  void onInit() async {
    super.onInit();
    if (type == "all") {
      var joinedCompanies = settingCtrl.user.companys;

      List<StoreTreeNav> organization = [];
      for (var value in joinedCompanies) {
        organization.add(
          StoreTreeNav(
            name: value.metadata.name ?? "",
            id: value.metadata.id,
            space: value,
            spaceEnum: SpaceEnum.company,
            children: [],
            image: value.metadata.avatarThumbnail(),
          ),
        );
      }
      state.nav = StoreTreeNav(
        name: HomeEnum.store.label,
        children: [
          StoreTreeNav(
            name: settingCtrl.provider.user?.metadata.name ?? "",
            id: settingCtrl.provider.user?.metadata.id ?? "",
            image: settingCtrl.provider.user?.metadata.avatarThumbnail(),
            children: [],
            space: settingCtrl.provider.user,
            spaceEnum: SpaceEnum.user,
          ),
          ...organization
        ],
      );
      await loadUserSetting();
      await loadCompanySetting();
    }
    loadSuccess();
  }

  Future<void> loadUserSetting() async {
    var user = state.nav!.children[0];

    user.onNext = (nav) async {
      await user.space!.loadContent(reload: true);
      List<StoreTreeNav> function = [
        StoreTreeNav(
          name: "个人文件",
          space: user.space,
          showPopup: false,
          spaceEnum: SpaceEnum.directory,
          children: [
            ...await loadApplications(
                user.space!.directory.applications, user.space!),
            ...await loadForm(user.space!.directory.forms, user.space!),
            ...await loadFile(user.space!.directory.files, user.space!),
          ],
        ),
      ];

      function
          .addAll(await loadDir(user.space!.directory.children, user.space!));
      function.addAll(
          await loadCohorts((user.space! as IBelong).cohorts, user.space!));
      nav.children = function;
    };
  }

  Future<void> loadCompanySetting() async {
    for (int i = 1; i < state.nav!.children.length; i++) {
      var company = state.nav!.children[i];
      await company.space!.loadContent(reload: true);
      company.onNext = (nav) async {
        List<StoreTreeNav> function = [
          StoreTreeNav(
            name: "单位文件",
            space: company.space,
            showPopup: false,
            spaceEnum: SpaceEnum.directory,
            children: [
              ...await loadApplications(
                  company.space!.directory.applications, company.space!),
              ...await loadForm(company.space!.directory.forms, company.space!),
              ...await loadFile(company.space!.directory.files, company.space!),
            ],
          ),
        ];
        function.addAll(
            await loadDir(company.space!.directory.children, company.space!));
        function.addAll(await loadTargets(
            (company.space!.targets.where((element) =>
                element.session.isMyChat && element.id != company.id)).toList(),
            company.space!));
        function.addAll(await loadGroup(
            (company.space! as Company).groups, company.space!));
        function.addAll(await loadCohorts(
            (company.space! as IBelong).cohorts, company.space!));
        nav.children = function;
      };
    }
  }

  void jumpDetails(StoreTreeNav nav) async {
    switch (nav.spaceEnum) {
      case SpaceEnum.departments:
        Get.toNamed(Routers.departmentInfo, arguments: {'depart': nav.source});
        break;
      case SpaceEnum.groups:
        Get.toNamed(Routers.outAgencyInfo, arguments: {'group': nav.source});
        break;
      case SpaceEnum.cohorts:
        Get.toNamed(Routers.cohortInfo, arguments: {'cohort': nav.source});
        break;
      case SpaceEnum.user:
        Get.toNamed(Routers.userInfo);
        break;
      case SpaceEnum.company:
        Get.toNamed(Routers.companyInfo, arguments: {"company": nav.space});
        break;
      case SpaceEnum.form:
        Get.toNamed(Routers.thing, arguments: {
          'form': nav.form ?? nav.source,
          "belongId": nav.space!.belongId
        });
        break;
      case SpaceEnum.species:
        Get.toNamed(Routers.thing, arguments: {
          'form': nav.form ?? nav.source,
          "belongId": nav.space!.belongId
        });
        break;
      case SpaceEnum.applications:
        var works = await nav.source.loadWorks();
        var target = nav.space;
        Get.toNamed(Routers.workStart,
            arguments: {"works": works, 'target': target});
        break;
      case SpaceEnum.file:
        RoutePages.jumpFile(file: nav.source!.shareInfo(), type: 'store');
        break;
      default:
        Get.toNamed(Routers.storeTree,
            preventDuplicates: false, arguments: {'data': nav});
        break;
    }
  }

  void onNext(StoreTreeNav nav) async {
    if (nav.source != null && nav.children.isEmpty) {
      jumpDetails(nav);
    } else {
      Get.toNamed(Routers.storeTree,
          preventDuplicates: false, arguments: {'data': nav});
    }
  }

  void operation(PopupMenuKey key, StoreTreeNav item) {
    switch (key) {
      case PopupMenuKey.shareQr:
        var entity;
        if (item.spaceEnum == SpaceEnum.user ||
            item.spaceEnum == SpaceEnum.company) {
          entity = item.space!.metadata;
        } else {
          entity = item.source.metadata;
        }
        Get.toNamed(
          Routers.shareQrCode,
          arguments: {"entity": entity},
        );
        break;
      default:
    }
  }

  @override
  void onClose() {
    state.scrollController.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    // TODO: implement onReady
  }

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    if (type != "all") {
      if (type == 'common') {
        //TODO 没有这个方法 用到梳理逻辑
        // await settingCtrl.store.loadMostUsed();
      } else {
        // await settingCtrl.store.loadRecentList();
      }
    }
  }

  void onSelected(key, StoreFrequentlyUsed store) {
    String id;
    if (store.fileItemShare != null) {
      id = base64.encode(utf8.encode(store.fileItemShare!.name!));
    } else {
      id = store.thing?.id ?? "";
    }
    //TODO：同上
    // settingCtrl.store.removeMostUsed(id);
  }
}
