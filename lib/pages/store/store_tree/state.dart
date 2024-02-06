import 'package:get/get.dart';
import 'package:orginone/components/base/group_nav_list/index.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/pages/store/models/index.dart';

class StoreTreeState extends BaseGroupNavListState<StoreTreeNavModel> {
  StoreTreeState() {
    model.value = Get.arguments is Map
        ? Get.arguments['data'] is StoreTreeNavModel
            ? Get.arguments['data']
            : null
        : null;

    ///返回的时候才会执行
    if (model.value == null) {
      var joinedCompanies = relationCtrl.user.companys;

      List<StoreTreeNavModel> organization = [];
      for (var value in joinedCompanies) {
        organization.add(
          StoreTreeNavModel(
            name: value.metadata.name ?? "",
            id: value.metadata.id,
            space: value,
            spaceEnum: SpaceEnum.company,
            children: [],
            image: value.metadata.avatarThumbnail(),
          ),
        );
      }
      model.value = StoreTreeNavModel(
        name: HomeEnum.store.label,
        children: [
          StoreTreeNavModel(
            name: relationCtrl.provider.user.metadata.name ?? "",
            id: relationCtrl.provider.user.metadata.id ?? "",
            image: relationCtrl.provider.user.metadata.avatarThumbnail(),
            children: [],
            space: relationCtrl.provider.user,
            spaceEnum: SpaceEnum.user,
          ),
          ...organization
        ],
      );
    }

    title = model.value?.name ?? "";
  }
}
