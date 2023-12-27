import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/outTeam/group.dart';
import 'package:orginone/pages/store/config.dart';
import 'package:orginone/utils/index.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:orginone/components/widgets/loading_dialog.dart';

import 'state.dart';

class StoreTreeController extends BaseBreadcrumbNavController<StoreTreeState> {
  @override
  final StoreTreeState state = StoreTreeState();

  Future<void> loadUserSetting() async {
    var user = state.model.value!.children[0];

    user.onNext = (nav) async {
      LogUtil.d('StoreTreeController-loadUserSetting');
      // await user.space!.loadContent(reload: true);
      await user.space!.directory.loadContent(reload: true);
      List<StoreTreeNav> function = [
        StoreTreeNav(
          name: "个人文件",
          space: user.space,
          showPopup: false,
          spaceEnum: SpaceEnum.directory,
          children: [
            ...await loadApplications(
                user.space!.directory.standard.applications, user.space!),
            ...await loadForm(
                user.space!.directory.standard.forms, user.space!),
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
    LogUtil.d('StoreTreeController-loadCompanySetting');
    for (int i = 1; i < state.model.value!.children.length; i++) {
      var company = state.model.value!.children[i];
      // await company.space!.directory.loadContent(reload: true);
      // await company.space!.loadContent(reload: true);
      LogUtil.d('loadCompanySetting-company');
      company.onNext = (nav) async {
        List<StoreTreeNav> function = [
          StoreTreeNav(
            name: "单位文件",
            space: company.space,
            showPopup: false,
            spaceEnum: SpaceEnum.directory,
            children: [
              // ...await loadApplications(
              //     company.space!.directory.standard.applications,
              //     company.space!),
              // ...await loadForm(
              //     company.space!.directory.standard.forms, company.space!),
              // ...await loadFile(company.space!.directory.files, company.space!),
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
            (company.space! as Group).children, company.space!));
        function.addAll(await loadCohorts(
            (company.space! as IBelong).cohorts, company.space!));
        nav.children = function;
      };
    }
  }

  @override
  void onReady() async {
    super.onReady();
    if (state.isRootDir && Get.arguments?['data'] == null) {
      LoadingDialog.showLoading(context);
      await loadUserSetting();
      await loadCompanySetting();
      state.model.refresh();
      LoadingDialog.dismiss(context);
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
      case SpaceEnum.work:
        WorkNodeModel? node = await nav.source.loadWorkNode();
        if (node != null && node.forms != null && node.forms!.isNotEmpty) {
          Get.toNamed(Routers.createWork, arguments: {
            "work": nav.source,
            "node": node,
            'target': nav.space
          });
        } else {
          ToastUtils.showMsg(msg: "流程未绑定表单");
        }
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
      case SpaceEnum.filter:
        Get.toNamed(Routers.thing, arguments: {
          'form': nav.form ?? nav.source,
          "belongId": nav.space!.belongId,
          'filter':
              (nav.source is FieldModel) ? nav.source?.code : nav.source?.value,
        });
        break;
      default:
        Get.toNamed(Routers.storeTree,
            preventDuplicates: false, arguments: {'data': nav});
        break;
    }
  }

  ///跳转下一页
  void onNext(StoreTreeNav nav) async {
    LogUtil.d('StoreTreeController-onNext');
    // await nav.space!.loadContent(reload: true);

    await nav.space?.directory.loadContent();
    List<StoreTreeNav> children = [
      ...await loadApplications(
          nav.space!.directory.standard.applications, nav.space!),
      ...await loadForm(nav.space!.directory.standard.forms, nav.space!),
      ...await loadFile(nav.space!.directory.files, nav.space!),
    ];

    nav.children = children;
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
      case PopupMenuKey.setCommon:
        //TODO:无此方法 用到是要看逻辑
        // settingCtrl.store.setMostUsed(
        //     file: FileItemModel.fromJson(
        //         (item.source as ISysFileInfo).shareInfo().toJson()),
        //     storeEnum: StoreEnum.file);
        break;
      case PopupMenuKey.removeCommon:
        // settingCtrl.store.removeMostUsed(item.id);
        break;
      default:
    }
  }

  @override
  void onTopPopupMenuSelected(PopupMenuKey key) {
    operation(key, state.model.value!);
  }
}
