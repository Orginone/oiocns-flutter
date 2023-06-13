import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/filesys/filesystem.dart';
import 'package:orginone/dart/core/thing/store/thingclass.dart';
import 'package:orginone/main.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'state.dart';

class StoreTreeController extends BaseBreadcrumbNavController<StoreTreeState> {
  final StoreTreeState state = StoreTreeState();

  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();

    LoadingDialog.showLoading(context);
    if(state.title == HomeEnum.store.label){
      List<ISpeciesItem> species = settingCtrl.store.findThingSpecies(state.model.value!.children[0].space!);
      state.model.value!.children[0].children.addAll(await buildSpeciesTree(species, state.model.value!.children[0].space!));
      state.model.refresh();
    } else if (state.model.value?.wareHouseType == WareHouseType.organization) {
      List<ISpeciesItem> species = settingCtrl.store.findThingSpecies(state.model.value!.space!);
      state.model.value?.children = [
        StoreTreeNav(
            name: PersonalEnum.file.label,
            personalEnum: PersonalEnum.file,
            children: [],
            space: state.model.value!.space!),
        ...await buildSpeciesTree(species, state.model.value!.space!),
      ];
      state.model.refresh();
    }
    LoadingDialog.dismiss(context);
  }

  Future<List<StoreTreeNav>> buildSpeciesTree(
      List<ISpeciesItem> species, IBelong space) async {
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
}
