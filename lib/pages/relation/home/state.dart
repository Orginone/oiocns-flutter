import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/main_base.dart';

class RelationCenterState extends BaseBreadcrumbNavState<RelationNavModel> {
  late bool isRelationSubPage;

  RelationCenterState() {
    model.value = Get.arguments?['data'];
    isRelationSubPage = Get.arguments?['isRelationSubPage'] ?? false;
    if (model.value == null) {
      var joinedCompanies = relationCtrl.provider.user.companys;
      model.value = RelationNavModel(name: "设置", children: [
        RelationNavModel(
          name: relationCtrl.provider.user.metadata.name ?? "",
          id: relationCtrl.provider.user.metadata.id ?? "",
          image: relationCtrl.provider.user.metadata.avatarThumbnail(),
          children: [],
          space: relationCtrl.provider.user,
          spaceEnum: SpaceEnum.user,
        ),
        ...joinedCompanies
                .map((element) => RelationNavModel(
                    name: element.metadata.name!,
                    id: element.metadata.id,
                    image: element.metadata.avatarThumbnail(),
                    space: element,
                    spaceEnum: SpaceEnum.company,
                    children: []))
                .toList() ??
            [],
      ]);
    }

    title = model.value!.name;
  }
}

class RelationNavModel extends BaseBreadcrumbNavModel<RelationNavModel> {
  IBelong? space;
  RelationNavModel({
    super.id = '',
    super.name = '',
    super.children = const [],
    super.source,
    super.image,
    super.spaceEnum,
    super.showPopup = true,
    super.onNext,
    this.space,
  });
}
