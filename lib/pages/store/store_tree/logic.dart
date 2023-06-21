import 'package:get/get.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/form.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/pages/store/config.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'state.dart';

class StoreTreeController extends BaseBreadcrumbNavController<StoreTreeState> {
  final StoreTreeState state = StoreTreeState();

  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();

    if (state.isRootDir) {
      LoadingDialog.showLoading(context);
      await loadUserSetting();
      await loadCompanySetting();
      LoadingDialog.dismiss(context);
      state.model.refresh();
    }
  }

  Future<void> loadUserSetting() async {
    var user = state.model.value!.children[0];
    List<StoreTreeNav> function = [
      StoreTreeNav(
        name: "个人文件",
        space: user.space,
        children: user.space!.directory.files.map((e) {
          return StoreTreeNav(
            name: e.filedata.name!,
            space: user.space,
            source: e,
            image: e.shareInfo().thumbnail,
            children: [],
          );
        }).toList(),
      ),
    ];

    function.addAll(await loadDir(user.space!.directory.children, user.space!));
    function.addAll(await loadCohorts(user.space!.cohorts, user.space!));
    user.children = function;
  }

  Future<void> loadCompanySetting() async {
    for (int i = 1; i < state.model.value!.children.length; i++) {
      var company = state.model.value!.children[i];
      List<StoreTreeNav> function = [
        StoreTreeNav(
          name: "单位文件",
          space: company.space,
          children: company.space!.directory.files.map((e) {
            return StoreTreeNav(
              name: e.filedata.name!,
              space: company.space,
              source: e,
              image: e.shareInfo().thumbnail,
              children: [],
            );
          }).toList(),
        ),
      ];
      function.addAll(
          await loadDir(company.space!.directory.children, company.space!));
      function.addAll(await loadTargets(
          (company.space!.targets.where(
                  (element) => element.isMyChat && element.id != company.id))
              .toList(),
          company.space!));
      function.addAll(
          await loadGroup((company.space! as Company).groups, company.space!));
      company.children.addAll(function);
    }
  }

  Future<List<StoreTreeNav>> buildSpeciesTree(
      List<ISpecies> species, IBelong space) async {
    List<StoreTreeNav> navs = [];

    for (var specie in species) {
      List<StoreTreeNav> thing = [];
      List<IForm> forms = await specie.directory.loadForms();
      thing.addAll(forms
          .map((e) => StoreTreeNav(
              children: [],
              source: e,
              name: e.metadata.name!,
              space: space))
          .toList());
      var nav = StoreTreeNav(
          children: [...thing],
          source: specie,
          name: specie.metadata.name!,
          space: space);
      navs.add(nav);
    }
    return navs;
  }

  void jumpDetails(StoreTreeNav nav) {
    Get.toNamed(Routers.thing, arguments: {
      'form': nav.source,
      "belongId": nav.space!.id
    });
  }

  void onNext(StoreTreeNav nav) {
    if (nav.source != null &&
        nav.source.metadata.typeName == SpeciesType.thing.label &&
        nav.children.isEmpty) {
      jumpDetails(nav);
    } else {
      Get.toNamed(Routers.storeTree,
          preventDuplicates: false, arguments: {'data': nav});
    }
  }
}
