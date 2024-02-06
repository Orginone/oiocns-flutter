import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/pages/relation/home/index.dart';
import 'package:orginone/pages/relation/widgets/dialog.dart';
import 'package:orginone/utils/toast_utils.dart';

import '../../../common/data_config/relation_config.dart';
import 'state.dart';

class RelationSubController extends BaseListController<RelationSubState> {
  @override
  final RelationSubState state = RelationSubState();

  late String type;

  RelationSubController(this.type);

  RelationSubController get allController => Get.find(tag: "Relation_all");

  @override
  void onInit() async {
    super.onInit();

    if (type == 'common') {
      state.shortcutDatas = [
        ...relationCtrl.menuItems,
      ];
      for (int index = 5; index < Shortcut.values.length; index++) {
        var short = Shortcut.values[index];
        state.shortcutDatas.add(ShortcutData(
          short,
          short.label,
        ));
      }
    }

    if (type == 'all') {
      var joinedCompanies = relationCtrl.provider.user.companys;
      state.nav.value = RelationNavModel(name: "设置", children: [
        RelationNavModel(
          name: relationCtrl.provider.user.metadata.name ?? "",
          id: relationCtrl.provider.user.metadata.id ?? "",
          image: relationCtrl.provider.user.metadata.avatarThumbnail(),
          children: [],
          space: relationCtrl.provider.user,
          spaceEnum: SpaceEnum.user,
        ),
        ...joinedCompanies
                .map((element) => RelationNavModel(
                    name: element.metadata.name!,
                    id: element.metadata.id,
                    image: element.metadata.avatarThumbnail(),
                    space: element,
                    spaceEnum: SpaceEnum.company,
                    children: []))
                .toList() ??
            [],
      ]);
      await loadUserRelation(state.nav);
      await loadCompanyRelation(state.nav);
      state.nav.refresh();
    }
    loadSuccess();
  }

  void onNextLv(RelationNavModel model) {
    if (model.children.isEmpty && model.spaceEnum != SpaceEnum.directory) {
      jumpDetails(model);
    } else {
      Get.toNamed(Routers.relationCenter,
          preventDuplicates: false,
          arguments: {"data": model, "isRelationSubPage": true});
    }
  }

  void jumpDetails(RelationNavModel model) {
    switch (model.spaceEnum) {
      case SpaceEnum.user:
        Get.toNamed(Routers.userInfo);
        break;
      case SpaceEnum.company:
        Get.toNamed(Routers.companyInfo, arguments: {"company": model.space});
        break;
      default:
    }
  }

  void updateInfo(PopupMenuKey key, RelationNavModel item) async {
    switch (item.spaceEnum) {
      case SpaceEnum.user:
      case SpaceEnum.company:
      case SpaceEnum.person:
      case SpaceEnum.departments:
      case SpaceEnum.groups:
      case SpaceEnum.cohorts:
        createTarget(key, item, isEdit: true, callback: ([nav]) {
          state.nav.refresh();
        });
        break;
      default:
    }
  }

  void operation(PopupMenuKey key, RelationNavModel item) {
    switch (key) {
      case PopupMenuKey.createDir:
        createDir(item, callback: () {
          state.nav.refresh();
        });
        break;
      case PopupMenuKey.createApplication:
        createApplication(item, callback: ([nav]) {
          state.nav.refresh();
        });
        break;
      case PopupMenuKey.createSpecies:
        createSpecies(item, '分类', callback: ([nav]) {
          state.nav.refresh();
        });
        break;
      case PopupMenuKey.createDict:
        createSpecies(item, '字典', callback: ([nav]) {
          state.nav.refresh();
        });
        break;
      case PopupMenuKey.createAttr:
        createAttr(item, callback: ([nav]) {
          state.nav.refresh();
        });
        break;
      case PopupMenuKey.createThing:
        createSpecies(item, '实体配置', callback: ([nav]) {
          state.nav.refresh();
        });
        break;
      case PopupMenuKey.createWork:
        createSpecies(item, '事项配置', callback: ([nav]) {
          state.nav.refresh();
        });
        break;
      case PopupMenuKey.createDepartment:
      case PopupMenuKey.createStation:
      case PopupMenuKey.createGroup:
      case PopupMenuKey.createCohort:
      case PopupMenuKey.createCompany:
        createTarget(key, item, callback: ([nav]) {
          if (key == PopupMenuKey.createCompany) {
            state.nav.value!.children.add(nav!);
          } else {
            item.children.add(nav!);
          }
          state.nav.refresh();
        });
        break;
      case PopupMenuKey.updateInfo:
        updateInfo(key, item);
        break;
      case PopupMenuKey.upload:
        uploadFile(item, callback: ([nav]) {
          state.nav.refresh();
        });
        break;
      case PopupMenuKey.shareQr:
        shareQr(item);
        break;
      case PopupMenuKey.openChat:
        openChat(item);
        break;
      default:
    }
  }

  @override
  void onReady() {}

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {}

  void clickCommon(ShortcutData item) {
    RelationNavModel model;
    try {
      model = allController.state.nav.value!.children[0];
    } catch (e) {
      model = RelationNavModel(
        space: relationCtrl.provider.user,
        spaceEnum: SpaceEnum.user,
      );
    }

    switch (item.shortcut) {
      case Shortcut.createCompany:
      case Shortcut.addCohort:
        showCreateOrganizationDialog(
          Get.context!,
          [item.targetType!],
          callBack: (String name, String code, String nickName, String identify,
              String remark, TargetType type) async {
            var target = TargetModel(
              name: nickName,
              code: code,
              typeName: type.label,
              teamName: name,
              teamCode: code,
              remark: remark,
            );
            var data = item.shortcut == Shortcut.createCompany
                ? await relationCtrl.user.createCompany(target)
                : await relationCtrl.user.createCohort(target);
            if (data != null) {
              ToastUtils.showMsg(msg: "创建成功");
            }
          },
        );
        break;
      case Shortcut.addPerson:
      case Shortcut.addGroup:
      case Shortcut.addCompany:
        showSearchDialog(Get.context!, item.targetType!,
            title: item.title, hint: item.hint, onSelected: (targets) async {
          if (targets.isNotEmpty) {
            bool success = await relationCtrl.user.applyJoin(targets);
            if (success) {
              ToastUtils.showMsg(msg: "发送申请成功");
            }
          }
        });
        break;
      case Shortcut.createDir:
        createDir(model, callback: () {
          try {
            allController.state.nav.refresh();
          } catch (e) {}
        });
        break;
      case Shortcut.createApplication:
        createApplication(model, callback: ([nav]) {
          try {
            allController.state.nav.refresh();
          } catch (e) {}
        });
        break;
      case Shortcut.createSpecies:
        createSpecies(model, '分类', callback: ([nav]) {
          try {
            allController.state.nav.refresh();
          } catch (e) {}
        });
        break;
      case Shortcut.createDict:
        createSpecies(model, '字典', callback: ([nav]) {
          try {
            allController.state.nav.refresh();
          } catch (e) {}
        });
        break;
      case Shortcut.createAttr:
        createAttr(model, callback: ([nav]) {
          try {
            allController.state.nav.refresh();
          } catch (e) {}
        });
        break;
      case Shortcut.createThing:
        createSpecies(model, '实体配置', callback: ([nav]) {
          try {
            allController.state.nav.refresh();
          } catch (e) {}
        });
        break;
      case Shortcut.createWork:
        createSpecies(model, '事项配置', callback: ([nav]) {
          try {
            allController.state.nav.refresh();
          } catch (e) {}
        });
        break;
      case Shortcut.uploadFile:
        uploadFile(model, callback: ([nav]) {
          try {
            allController.state.nav.refresh();
          } catch (e) {}
        });
        break;
    }
  }
}
