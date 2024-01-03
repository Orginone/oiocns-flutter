import 'package:orginone/dart/core/getx/submenu_list/base_submenu_state.dart';

class PortalState extends BaseSubmenuState<PortalFrequentlyUsed> {
  @override
  String get tag => "门户";
}

class PortalFrequentlyUsed extends FrequentlyUsed {
  PortalFrequentlyUsed({super.id, super.name, super.avatar});
}
