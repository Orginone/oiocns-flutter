import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/common_widget.dart';

class Messages extends BaseBreadcrumbNavMultiplexPage<Controller, State> {
  @override
  Widget body() {
    var userName = controller.settingCtrl.provider.user?.metadata.name;
    var companies = <Widget>[];
    for (var e in state.settingCtrl.provider.user?.companys??[]) {
      companies.add(CommonWidget.commonHeadInfoWidget(e.name));
      companies.add(BaseBreadcrumbNavItem(
        item: BaseBreadcrumbNavModel(name: e.name, children: []),
        onTap: () {
          e.chat.onMessage();
          Get.toNamed(Routers.messageChat, arguments: e.chat);
        },
      ));
      companies.addAll(OrganizationEnum.values.map((e) {
        return BaseBreadcrumbNavItem(
          item: BaseBreadcrumbNavModel(name: e.label, children: []),
          onTap: () {
            // controller.jumpUniversalNavigator(e.name);
          },
        );
      }));
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: Column(
          children: [
            CommonWidget.commonHeadInfoWidget(userName??""),
            BaseBreadcrumbNavItem(
              item: BaseBreadcrumbNavModel(name: userName??"", children: []),
              onTap: () {
                // controller.jumpUniversalNavigator(e);
              },
            ),
            ...PersonEnum.values.map((e) {
              return BaseBreadcrumbNavItem(
                item: BaseBreadcrumbNavModel(name: e.label, children: []),
                onTap: () {
                  // controller.jumpUniversalNavigator(e);
                },
              );
            }).toList(),
            ...companies
          ],
        ),
      ),
    );
  }

  @override
  Controller getController() {
    return Controller();
  }
}

class Controller extends BaseBreadcrumbNavController<State> {
  final settingCtrl = Get.find<SettingController>();

  @override
  final State state = State();
}

class State extends BaseBreadcrumbNavState {
  SettingController get settingCtrl => Get.find<SettingController>();

  State() {
    var joinedCompanies = settingCtrl.provider.user?.companys;

    model.value = Get.arguments?['data'];

    if (model.value == null && joinedCompanies!=null) {
      List<ChatBreadcrumbNav> organization = [];
      for (var value in joinedCompanies) {
        organization.add(
          ChatBreadcrumbNav(
            name: value.metadata.name,
            id: value.metadata.id,
            space: value,
            children: [
              ChatBreadcrumbNav(
                name: OrganizationEnum.inner.label,
                organizationEnum: OrganizationEnum.inner,
                children: [],
              ),
              ChatBreadcrumbNav(
                name: OrganizationEnum.job.label,
                organizationEnum: OrganizationEnum.job,
                children: [],
              ),
              ChatBreadcrumbNav(
                name: OrganizationEnum.innerCohorts.label,
                organizationEnum: OrganizationEnum.innerCohorts,
                children: [],
              ),
              ChatBreadcrumbNav(
                name: OrganizationEnum.outerCohorts.label,
                organizationEnum: OrganizationEnum.outerCohorts,
                children: [],
              ),
              ChatBreadcrumbNav(
                name: OrganizationEnum.authCohorts.label,
                organizationEnum: OrganizationEnum.authCohorts,
                children: [],
              ),
            ],
            image: value.metadata.avatarThumbnail(),
          ),
        );
      }
      model.value = ChatBreadcrumbNav(
        name: "沟通",
        children: [],
      );
    }

    title = model.value?.name??"";
  }
}

class MessagesBinding extends BaseBindings<Controller> {
  @override
  Controller getController() {
    return Controller();
  }
}

class ChatBreadcrumbNav extends BaseBreadcrumbNavModel<ChatBreadcrumbNav> {
  OrganizationEnum? organizationEnum;
  IBelong? space;
  PersonEnum? workType;

  ChatBreadcrumbNav(
      {super.id = '',
      super.name = '',
      required List<ChatBreadcrumbNav> children,
      super.image,
      super.source,
      this.organizationEnum,
      this.space,
      this.workType}) {
    this.children = children;
  }
}

enum PersonEnum {
  myFriends("我的好友"),
  myCohorts("我的群组");

  final String label;

  const PersonEnum(this.label);
}

enum OrganizationEnum {
  inner("内部机构"),
  job("单位岗位"),
  innerCohorts("内部群组"),
  outerCohorts("对外群组"),
  authCohorts("单位权限群");

  final String label;

  const OrganizationEnum(this.label);
}
