import 'dart:convert';

import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/thing/form.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/images.dart';
import 'package:orginone/main.dart';
import 'package:orginone/model/thing_model.dart' as thing;
import 'package:orginone/pages/store/logic.dart';
import 'package:orginone/pages/store/state.dart';

abstract class IStoreProvider {
  late IPerson user;

  late RxList<StoreFrequentlyUsed> storeFrequentlyUsed;

  late RxList<RecentlyUseModel> recent;

  List<ISpecies> findThingSpecies(IBelong belong);

  Future<void> onRecordRecent(RecentlyUseModel data);

  Future<void> loadRecentList();

  Future<void> loadMostUsed();

  Future<void> setMostUsed(
      {thing.ThingModel? thing,
      FileItemModel? file,
      required StoreEnum storeEnum});

  Future<void> removeMostUsed(String id);

  Future<IForm?> findForm(String id);

  bool isMostUsed(String id);
}

class StoreProvider implements IStoreProvider {

  StoreController get storeController => Get.find(tag: 'store');

  StoreProvider(this.user) {
    storeFrequentlyUsed = RxList();
    recent = RxList();
  }

  @override
  late IPerson user;

  @override
  late RxList<StoreFrequentlyUsed> storeFrequentlyUsed;

  @override
  Future<IForm?> findForm(String id) async {
    var species = findThingSpecies(user);
    for (var specie in species) {
      var forms = await specie.directory.loadForms();
      for (var form in forms) {
        if(form.metadata.id == id){
          return form;
        }
      }
    }
    for (var target in user.targets) {
      var forms = await target.directory.loadForms();
      for (var form in forms) {
        if(form.metadata.id == id){
          return form;
        }
      }
    }
    return null;
  }

  @override
  List<ISpecies> findThingSpecies(ITarget belong) {
    List<ISpecies> species = [];
    for (var element in belong.directory.specieses) {
      if (element.metadata.belongId == belong.id) {
        if (SpeciesType.thing.label == element.metadata.typeName) {
          species.add(element);
        }
      }
    }
    return species;
  }

  @override
  Future<void> loadMostUsed() async {
    var res = await kernel.anystore.get(
      "${StoreCollName.mostUsed}.stores",
      user.id,
    );
    if (res.success && res.data != null) {
      storeFrequentlyUsed.clear();
      var stores = res.data;
      if (stores is Map<String, dynamic>) {
        for (var key in stores.keys) {
          var id = key.substring(1);
          String type = stores[key]?['type'] ?? "";
          if (type == StoreEnum.file.label) {
            var data = FileItemModel.fromJson(stores[key]);
            storeFrequentlyUsed.add(StoreFrequentlyUsed(
                fileItemShare: data,
                name: data.name,
                id: id,
                avatar: getFileAvatar(data),
                storeEnum: StoreEnum.file));
          } else if (type == StoreEnum.thing.label) {
            var data = thing.ThingModel.fromJson(stores[key]);
            storeFrequentlyUsed.add(StoreFrequentlyUsed(
                name: data.id,
                id: id,
                thing: data,
                storeEnum: StoreEnum.thing));
          }
        }
      }
    }
    storeController.loadFrequentlyUsed();
  }

  @override
  Future<void> loadRecentList() async {
    var res = await kernel.anystore.get(
      "${StoreCollName.storeOpen}.stores",
      user.id,
    );
    if (res.success && res.data != null) {
      recent.clear();
      var stores = res.data;
      if (stores is Map<String, dynamic>) {
        for (var key in stores.keys) {
          recent.add(RecentlyUseModel.fromJson(stores[key]));
        }
        recent.sort((a,b){
          return DateTime.parse(b.createTime).compareTo(DateTime.parse(a.createTime));
        });
      }
    }
  }

  @override
  Future<void> removeMostUsed(String id) async {
    var res = await kernel.anystore.delete(
      "${StoreCollName.mostUsed}.stores.T$id",
      user.id,
    );
    if (res.success) {
      storeFrequentlyUsed.removeWhere((p0) => p0.id == id);
      storeFrequentlyUsed.refresh();
    }
  }

  @override
  Future<void> setMostUsed(
      {thing.ThingModel? thing,
      FileItemModel? file,
      required StoreEnum storeEnum}) async {
    Map<String, dynamic> data = {"type": storeEnum.label};
    String id = '';
    StoreFrequentlyUsed? used;
    switch (storeEnum) {
      case StoreEnum.file:
        id = base64.encode(utf8.encode(file!.name!));
        data.addAll(file.toJson());
        used = StoreFrequentlyUsed(
            fileItemShare: file,
            id: id,
            name: file.name,
            avatar: getFileAvatar(file),
            storeEnum: storeEnum);
        break;
      case StoreEnum.thing:
        id = thing!.id!;
        data.addAll(thing.toJson());
        used = StoreFrequentlyUsed(
            thing: thing, id: id, name: id, storeEnum: storeEnum);
        break;
    }
    var res = await kernel.anystore.set(
      "${StoreCollName.mostUsed}.stores.T$id",
      {
        'data': data,
      },
      user.id,
    );
    if (res.success) {
      storeFrequentlyUsed.add(used);
    }
  }

  @override
  bool isMostUsed(String id) {
    return storeFrequentlyUsed.where((p0) => p0.id == id).isNotEmpty;
  }


  @override
  Future<void> onRecordRecent(RecentlyUseModel data) async {
    var res = await kernel.anystore.set(
      "${StoreCollName.storeOpen}.stores.T${data.id}",
      {
        "operation": "replaceAll",
        'data': data.toJson(),
      },
      user.id,
    );
    if(res.success){
      if(recent.where((p0) => p0.id == data.id).isNotEmpty){
        recent.removeWhere((element) => element.id == data.id);
      }
      recent.insert(0,data);
    }
  }

  @override
  late RxList<RecentlyUseModel> recent;
}

dynamic getFileAvatar(FileItemModel data) {
  String ext = data.name!.split('.').last.toLowerCase();
  if (ext == 'jpg' || ext == 'jpeg' || ext == 'png' || ext == 'webp') {
    return data.shareLink;
  } else {
    switch (ext) {
      case "xlsx":
      case "xls":
      case "excel":
        return Images.excelIcon;
      case "pdf":
        return Images.pdfIcon;
      case "ppt":
        return Images.pptIcon;
      case "docx":
      case "doc":
        return Images.wordIcon;
      default:
        return Images.otherIcon;
    }
  }
}