import 'package:orginone/components/widgets/loading_dialog.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ThingInfoController extends BaseController<ThingInfoState> {
  @override
  final ThingInfoState state = ThingInfoState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);
    state.attr.value = state.form.attributes;
    // for (var element in state.attr) {
    //   if (element.valueType == "附件型") {
    //   if (false) {
    //     try {
    //       List<dynamic> files = jsonDecode(state.thing.propertys[element.code]);
    //       List<FileItemShare> share =
    //           files.map((e) => FileItemShare.fromJson(e)).toList();
    //       element.value = share.map((e) => e.name).join('\n');
    //       element.share = share;
    //     } catch (e) {}
    //   } else {
    //     element.value = state.thing.propertys[element.code];
    //   }
    // }
    LoadingDialog.dismiss(context);
    state.attr.refresh();
  }
}
