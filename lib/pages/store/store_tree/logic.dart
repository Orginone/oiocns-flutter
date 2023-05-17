import 'package:get/get.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/app/work/workform.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/base/work.dart';
import 'package:orginone/dart/core/thing/market/commodity.dart';
import 'package:orginone/dart/core/thing/store/propclass.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'state.dart';

class StoreTreeController extends BaseBreadcrumbNavController<StoreTreeState> {
  final StoreTreeState state = StoreTreeState();

  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    if (state.model.value?.wareHouseType == WareHouseType.organization) {
      LoadingDialog.showLoading(context);
      List<StoreTreeNav> children = [];
      children.addAll(await buildSpeciesTree(state.model.value!.space!.species,
          state.model.value!.space as ICompany));
      children.addAll(await buildTargetTree(state.model.value!.space as ICompany));

      state.model.value?.children = children;
      LoadingDialog.dismiss(context);
      state.model.refresh();
    }
  }

  Future<List<StoreTreeNav>> buildTargetTree(ICompany space) async {
    List<StoreTreeNav> navs = [];

    for (var item in space.targets.skip(1)) {
      var children = await buildSpeciesTree(space.species, space);

      if (item.species.isNotEmpty) {
        var nav = StoreTreeNav(
            children: children,
            source: item,
            name: item.metadata.name,
            wareHouseType: WareHouseType.target,
            space: space);
        navs.add(nav);
      }
    }
    return navs;
  }

  Future<List<StoreTreeNav>> buildSpeciesTree(
      List<ISpeciesItem> species, ICompany space) async {
    List<StoreTreeNav> navs = [];

    for (var specie in species) {
      var type = SpeciesType.getType(specie.metadata.typeName)!;
      switch (type) {
        case SpeciesType.fileSystem:
          var nav = StoreTreeNav(
              children: [],
              source: specie,
              speciesType: SpeciesType.fileSystem,
              name: SpeciesType.fileSystem.label,
              space: space);
          navs.add(nav);
          break;
        case SpeciesType.market:
        case SpeciesType.store:
        case SpeciesType.application:
        case SpeciesType.commodity:
        case SpeciesType.appModule:
          switch (type) {
            case SpeciesType.market:
            case SpeciesType.workItem:
              await (specie as IWork).loadWorkDefines();
              break;
            case SpeciesType.commodity:
              await (specie as ICommodity).loadForm();
              break;
            case SpeciesType.store:
              await (specie as IPropClass).loadPropertys();
              break;
          }
          var children = await buildSpeciesTree(specie.children, space);
          var nav = StoreTreeNav(
              children: children,
              source: specie,
              speciesType: SpeciesType.getType(specie.metadata.typeName),
              name: specie.metadata.name,
              space: space);
          navs.add(nav);
          break;
        case SpeciesType.workForm:
          var nav = StoreTreeNav(
              children: (specie as IWorkForm)
                  .forms
                  .map((e) => StoreTreeNav(
                      children: [],
                      source: e,
                      name: e.metadata.name,
                      speciesType: SpeciesType.workForm,
                      space: space))
                  .toList(),
              source: specie,
              speciesType: SpeciesType.workForm,
              name: SpeciesType.workForm.label,
              space: space);
          navs.add(nav);
          break;
      }
    }
    return navs;
  }

  void jumpDetails(StoreTreeNav nav) {

  }

  void onNext(StoreTreeNav nav) {
    Get.toNamed(Routers.storeTree,
        preventDuplicates: false, arguments: {'data': nav});
  }
}
