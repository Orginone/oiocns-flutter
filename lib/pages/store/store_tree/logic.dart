import 'package:get/get.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/app/workthing.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/filesys/filesystem.dart';
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
      ICompany space = state.model.value!.space! as ICompany;
      List<ISpeciesItem> species = filterSpecies(space);
      state.model.value?.children.addAll(await buildSpeciesTree(species, space));
      LoadingDialog.dismiss(context);
      state.model.refresh();
    }
  }

  Future<List<StoreTreeNav>> buildSpeciesTree(
      List<ISpeciesItem> species, ICompany space) async {
    List<StoreTreeNav> navs = [];

    for (var specie in species) {
      var type = SpeciesType.getType(specie.metadata.typeName)!;
      switch (type) {
        case SpeciesType.market:
        case SpeciesType.store:
        case SpeciesType.application:
        case SpeciesType.workThing:
          List<StoreTreeNav> thing = [];
          if (type == SpeciesType.workThing) {
            List<IForm> forms = await (specie as IWorkThing).loadForms();
            thing.addAll(forms
                .map((e) => StoreTreeNav(
                    children: [],
                    source: e,
                    name: e.metadata.name,
                    speciesType: SpeciesType.workThing,
                    space: space))
                .toList());
          }
          if (type == SpeciesType.store) {
            await (specie as IPropClass).loadPropertys();
          }
          var children = await buildSpeciesTree(specie.children, space);
          var nav = StoreTreeNav(
              children: [...thing, ...children],
              source: specie,
              speciesType: SpeciesType.getType(specie.metadata.typeName),
              name: specie.metadata.name,
              space: space);
          navs.add(nav);
          break;
      }
    }
    return navs;
  }

  void jumpDetails(StoreTreeNav nav) {
    jumpFile(nav);
  }

  void jumpFile(StoreTreeNav nav) {
    IFileSystemItem file = nav.space!.fileSystem.home!;
    Get.toNamed(Routers.file, arguments: {"file": file});
  }

  void onNext(StoreTreeNav nav) {
    if (nav.personalEnum == PersonalEnum.file) {
      jumpFile(nav);
    } else {
      Get.toNamed(Routers.storeTree,
          preventDuplicates: false, arguments: {'data': nav});
    }
  }

  List<ISpeciesItem> filterSpecies(IBelong space) {
    List<ISpeciesItem> species = [];
    for (var element in state.model.value!.space!.targets) {
      if (element.space == space) {
        for (var s in element.species) {
          switch (SpeciesType.getType(s.metadata.typeName)) {
            case SpeciesType.store:
            case SpeciesType.market:
            case SpeciesType.application:
              species.add(s);
              break;
          }
        }
      }
    }

    return species;
  }
}
