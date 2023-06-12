import 'package:get/get.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/filesys/filesystem.dart';
import 'package:orginone/dart/core/thing/store/thingclass.dart';
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
      state.model.value?.children = await buildSpeciesTree(species, space);
      LoadingDialog.dismiss(context);
      state.model.refresh();
    }
  }

  Future<List<StoreTreeNav>> buildSpeciesTree(
      List<ISpeciesItem> species, ICompany space) async {
    List<StoreTreeNav> navs = [];

    for (var specie in species) {
      List<StoreTreeNav> thing = [];
      List<IForm> forms = await (specie as IThingClass).loadForms();
      thing.addAll(forms
          .map((e) => StoreTreeNav(
              children: [],
              source: e,
              name: e.metadata.name,
              speciesType: SpeciesType.thing,
              space: space))
          .toList());
      var nav = StoreTreeNav(
          children: [...thing],
          source: specie,
          speciesType: SpeciesType.getType(specie.metadata.typeName),
          name: specie.metadata.name,
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

  void jumpFile(StoreTreeNav nav) {
    IFileSystemItem file = nav.space!.fileSystem.home!;
    Get.toNamed(Routers.file, arguments: {"file": file});
  }

  void onNext(StoreTreeNav nav) {
    if (nav.personalEnum == PersonalEnum.file) {
      jumpFile(nav);
    } else if (nav.source != null &&
        nav.source.metadata.typeName == SpeciesType.thing.label &&
        nav.children.isEmpty) {
      jumpDetails(nav);
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
          if (SpeciesType.thing.label == s.metadata.typeName) {
            species.add(s);
          }
        }
      }
    }

    return species;
  }
}
