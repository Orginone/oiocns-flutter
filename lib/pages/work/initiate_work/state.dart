import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/target/base/belong.dart';

class InitiateWorkState extends BaseBreadcrumbNavState<WorkBreadcrumbNav> {
  SettingController get settingCtrl => Get.find<SettingController>();

  InitiateWorkState() {
    var joinedCompanies = settingCtrl.user.companys;

    model.value = Get.arguments?['data'];

    if (model.value == null) {
      List<WorkBreadcrumbNav> organization = [];
      for (var value in joinedCompanies) {
        organization.add(
          WorkBreadcrumbNav(
              name: value.metadata.name??"",
              id: value.metadata.id,
              space: value,
              children: [
                WorkBreadcrumbNav(
                    name: WorkEnum.initiationWork.label,
                    workEnum: WorkEnum.initiationWork, children: [],space: value),
                WorkBreadcrumbNav(
                    name: WorkEnum.todo.label, workEnum: WorkEnum.todo, children: [],space: value),
                WorkBreadcrumbNav(
                    name: WorkEnum.completed.label, workEnum: WorkEnum.completed, children: [],space: value),
                WorkBreadcrumbNav(
                    name: WorkEnum.initiated.label, workEnum: WorkEnum.initiated, children: [],space: value),
              ],
              image: value.metadata.avatarThumbnail(),
          ),
        );
      }
      model.value = WorkBreadcrumbNav(
        name: "发起办事",
        children: [
          WorkBreadcrumbNav(
            name: "个人",
            children: [
              WorkBreadcrumbNav(
                  name: WorkEnum.initiationWork.label,
                  workEnum: WorkEnum.initiationWork, children: [],space: settingCtrl.user),
              WorkBreadcrumbNav(
                  name: WorkEnum.todo.label, workEnum: WorkEnum.todo, children: [],space: settingCtrl.user),
              WorkBreadcrumbNav(
                  name: WorkEnum.completed.label, workEnum: WorkEnum.completed, children: [],space: settingCtrl.user),
              WorkBreadcrumbNav(
                  name: WorkEnum.initiated.label, workEnum: WorkEnum.initiated, children: [],space: settingCtrl.user),
            ],
            space: settingCtrl.user
          ),
          WorkBreadcrumbNav(
            name: '组织',
            children: organization,
          ),
        ],
      );
    }

    title = model.value!.name;
  }
}

class WorkBreadcrumbNav extends BaseBreadcrumbNavModel<WorkBreadcrumbNav> {
  WorkEnum? workEnum;
  IBelong? space;
  WorkBreadcrumbNav(
      {super.id = '',
      super.name = '',
      required List<WorkBreadcrumbNav> children,
      super.image,
      super.source,
      this.workEnum,
      this.space}){
   this.children = children;
  }
}

enum WorkEnum {
  initiationWork("发起事项"),
  todo("待办事项"),
  completed("已办事项"),
  initiated("我发起的");

  final String label;

  const WorkEnum(this.label);
}
