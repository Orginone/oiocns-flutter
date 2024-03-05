import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/dart/base/schema.dart';

class SubFormController extends GetxController {
  SubFormController();

  _initData() {
    update(["sub_form"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

//跳转到详情
  toDetail(XForm form, int infoIndex) {
    Get.toNamed(Routers.formDetail,
        arguments: RouterParam(
            parents: [
              // ..._getParentRouteParams(),
              if (null != form) RouterParam(datas: form)
            ],
            // parents: [..._getParentRouteParams(), RouterParam(datas: parentData.metadata)],
            // defaultActiveTabs: defaultActiveTabs ?? [TargetType.person.label],
            datas: {
              "form": form,
              'infoIndex': infoIndex
            }));
    // Get.toNamed(Routers.formDetail,
    //     arguments: {"form": form, 'infoIndex': infoIndex});
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
