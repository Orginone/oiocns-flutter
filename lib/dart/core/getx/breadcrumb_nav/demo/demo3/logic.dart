import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/utils/log/log_util.dart';

import 'state.dart';

class Demo3Controller extends BaseBreadcrumbNavController<Demo3State> {
  @override
  final Demo3State state = Demo3State();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    LogUtil.d(state.bcNav);
  }
}
