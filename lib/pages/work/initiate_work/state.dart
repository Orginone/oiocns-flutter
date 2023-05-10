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
              workType: WorkType.organization,
              children: [
                WorkBreadcrumbNav(
                    name: WorkEnum.outAgency.label,
                    workEnum: WorkEnum.outAgency,
                    space: value, children: []),
                WorkBreadcrumbNav(
                    name: WorkEnum.workCohort.label,
                    workEnum: WorkEnum.workCohort,
                    space: value, children: []),
              ],
              image: value.metadata.avatarThumbnail(),
          ),
        );
      }
      model.value = WorkBreadcrumbNav(
        name: "发起办事",
        children: [
          WorkBreadcrumbNav(
            name: WorkType.personal.label,
            children: [
              WorkBreadcrumbNav(
                  name: WorkEnum.addFriends.label,
                  workEnum: WorkEnum.addFriends, children: []),
              WorkBreadcrumbNav(
                  name: WorkEnum.addUnits.label, workEnum: WorkEnum.addUnits, children: []),
              WorkBreadcrumbNav(
                  name: WorkEnum.addGroup.label, workEnum: WorkEnum.addGroup, children: []),
            ],
            space: settingCtrl.user
          ),
          WorkBreadcrumbNav(
            name: WorkType.organization.label,
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
  WorkType? workType;
  WorkBreadcrumbNav(
      {super.id = '',
      super.name = '',
      required List<WorkBreadcrumbNav> children,
      super.image,
      super.source,
      this.workEnum,
      this.space,this.workType}){
   this.children = children;
  }
}

enum WorkType {
  personal("个人"),
  organization("组织"),
  group("组");
  final String label;
  const WorkType(this.label);
}

enum WorkEnum {
  addFriends("加好友"),
  addUnits("加单位"),
  addGroup("加群"),
  outAgency("外部机构"),
  workCohort("单位群组");

  final String label;

  const WorkEnum(this.label);
}
