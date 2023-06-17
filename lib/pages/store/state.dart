import 'dart:convert';

import 'package:orginone/dart/base/model.dart' hide ThingModel;
import 'package:orginone/dart/core/getx/frequently_used_list/base_frequently_used_list_state.dart';
import 'package:orginone/dart/core/thing/store/provider.dart';
import 'package:orginone/model/thing_model.dart';

class StoreState
    extends BaseFrequentlyUsedListState<StoreFrequentlyUsed, dynamic> {}

class StoreFrequentlyUsed extends FrequentlyUsed {
  FileItemModel? fileItemShare;

  ThingModel? thing;

  StoreEnum storeEnum;

  StoreFrequentlyUsed(
      {super.avatar,
      super.name,
      super.id,
      this.fileItemShare,
      this.thing,
      required this.storeEnum});
}

enum StoreEnum {
  file("file"),
  thing("thing");

  final String label;

  const StoreEnum(this.label);
}

class RecentlyUseModel {
  FileItemModel? file;

  ThingModel? thing;

  late String createTime;

  late String type;

  late String id;

  dynamic avatar;

  RecentlyUseModel({required this.type, this.thing, this.file}) {
    createTime = DateTime.now().toString();
    id = thing?.id ?? base64.encode(utf8.encode(file?.name ?? ''));
    loadAvatar();
  }

  RecentlyUseModel.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    type = json['type'];
    id = json['id'];
    thing = json['thing'] != null ? ThingModel.fromJson(json['thing']) : null;
    file = json['file'] != null ? FileItemModel.fromJson(json['file']) : null;
    loadAvatar();
  }

  loadAvatar() {
    if (file != null) {
      avatar = getFileAvatar(file!);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'createTime': createTime,
      'thing': thing?.toJson(),
      'file': file?.toJson(),
    };
  }
}