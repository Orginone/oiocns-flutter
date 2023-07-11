

import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/target/base/target.dart';

class GeneralBreadCrumbsState extends BaseBreadcrumbNavState{

  GeneralBreadCrumbsState(){
    model.value = Get.arguments?['data'];
    title = model.value?.name??'';
  }
}

class GeneralBreadcrumbNav extends BaseBreadcrumbNavModel<GeneralBreadcrumbNav> {
  ITarget? space;

  GeneralBreadcrumbNav({super.id = '',
    super.name = '',
    required List<GeneralBreadcrumbNav> children,
    super.image,
    super.source,
    super.spaceEnum,
    super.onNext,
    this.space}) {
    this.children = children;
  }
}