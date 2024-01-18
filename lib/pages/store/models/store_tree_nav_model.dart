import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/standard/index.dart';

class StoreTreeNavModel extends BaseBreadcrumbNavModel<StoreTreeNavModel> {
  ITarget? space;
  IForm? form;
  StoreTreeNavModel(
      {super.id = '',
      super.name = '',
      required List<StoreTreeNavModel> children,
      super.image,
      super.source,
      super.showPopup = true,
      super.onNext,
      this.space,
      this.form,
      super.spaceEnum}) {
    this.children = children;
  }
}
