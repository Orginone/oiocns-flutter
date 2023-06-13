import 'dart:convert';

import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/market/model.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/store/thingclass.dart';
import 'package:orginone/images.dart';
import 'package:orginone/model/thing_model.dart' as thing;
import 'package:orginone/pages/store/state.dart';

abstract class IStoreProvider {
  late IPerson user;

  late RxList<StoreRecent> storeRecent;

  List<ISpeciesItem> findThingSpecies(IBelong belong);

  Future<void> loadRecentList();

  Future<void> loadMostUsed();

  Future<void> setThingMostUsed(thing.ThingModel data);

  Future<void> setFileMostUsed(FileItemModel data);

  Future<void> removeMostUsed(String id);

  Future<IForm?> findForm(String id);

  bool isMostUsed(String id);
}

class StoreProvider implements IStoreProvider {
  StoreProvider(this.user) {
    storeRecent = RxList();
  }

  @override
  late IPerson user;

  @override
  late RxList<StoreRecent> storeRecent;

  @override
  Future<IForm?> findForm(String id) async{
    var species = findThingSpecies(user);
    for (var specie in species) {
      var forms = await (specie as IThingClass).loadForms();
      for (var form in forms) {
        if(form.metadata.id == id){
          return form;
        }
      }
    }
    for (var target in user.targets) {
      var species = findThingSpecies(target);
      for (var specie in species) {
        var forms = await (specie as IThingClass).loadForms();
        for (var form in forms) {
          if(form.metadata.id == id){
            return form;
          }
        }
      }
    }
    return null;
  }

  @override
  List<ISpeciesItem> findThingSpecies(ITarget belong) {
    List<ISpeciesItem> species = [];
    for (var element in belong.targets) {
      if (element.space == belong) {
        for (var s in element.species) {
          if (SpeciesType.thing.label == s.metadata.typeName) {
            species.add(s);
          }
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
      storeRecent.clear();
      var stores = res.data;
      if (stores is Map<String, dynamic>) {
        for (var key in stores.keys) {
          var id = key.substring(1);
          String type = stores[key]?['type'] ?? "";
          if (type == StoreEnum.file.label) {
            var data = FileItemModel.fromJson(stores[key]);
            storeRecent.add(StoreRecent(
                fileItemShare: data,
                name: data.name,
                id: id,
                avatar: getFileAvatar(data),
                storeEnum: StoreEnum.file));
          } else if (type == StoreEnum.thing.label) {
            var data = thing.ThingModel.fromJson(stores[key]);
            storeRecent.add(StoreRecent(
                name: data.id,
                id: id,
                thing: data,
                storeEnum: StoreEnum.thing));
          }
        }
      }
    }
  }

  @override
  Future<void> loadRecentList() async {}

  @override
  Future<void> removeMostUsed(String id) async {
    var res = await kernel.anystore.delete(
      "${StoreCollName.mostUsed}.stores.T$id",
      user.id,
    );
    if (res.success) {
      storeRecent.removeWhere((p0) => p0.id == id);
      storeRecent.refresh();
    }
  }

  @override
  Future<void> setThingMostUsed(thing.ThingModel data) async {
    var res = await kernel.anystore.set(
      "${StoreCollName.mostUsed}.stores.T${data.id}",
      {
        'data': {
          'type': 'thing',
          ...data.toJson(),
        },
      },
      user.id,
    );
    if (res.success) {
      StoreRecent recent = StoreRecent(
          thing: data, id: data.id, name: data.id, storeEnum: StoreEnum.thing);
      storeRecent.add(recent);
    }
  }

  @override
  Future<void> setFileMostUsed(FileItemModel data) async {
    String id = base64.encode(utf8.encode(data.name!));
    var res = await kernel.anystore.set(
      "${StoreCollName.mostUsed}.stores.T$id",
      {
        'data': {'type': 'file', ...data.toJson()},
      },
      user.id,
    );
    if (res.success) {
      StoreRecent recent = StoreRecent(
          fileItemShare: data,
          id: id,
          name: data.name,
          avatar: getFileAvatar(data),
          storeEnum: StoreEnum.file);
      storeRecent.add(recent);
    }
  }

  @override
  bool isMostUsed(String id) {
    return storeRecent.where((p0) => p0.id == id).isNotEmpty;
  }

  dynamic getFileAvatar(FileItemModel data) {
    String ext = data.name!.split('.').last.toLowerCase();
    if (ext == 'jpg' || ext == 'jpeg' || ext == 'png' || ext == 'webp') {
      return data.shareInfo()['shareLink'];
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
}
