import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/store/state.dart';

/// 存储资源接口
abstract class IStorage implements ITarget {
  late RxList<RecentlyUseModel> recent;

  /// 是否处于激活状态
  bool get isActivate;

  /// 激活存储
  Future<bool> activateStorage();
}

class Storage extends Target implements IStorage {
  Storage(
    this.metadata,
    this.relations,
    this.space,
  ) : super([space.key], metadata, [...relations, metadata.id],
            space: space,
            user: space.user,
            memberTypes: [
              TargetType.company,
              TargetType.hospital,
              TargetType.university,
              TargetType.person,
            ]) {
    recent = RxList();
  }

  @override
  final XTarget metadata;
  @override
  final List<String> relations;
  @override
  final IBelong space;
  @override
  Future<bool> exit() async {
    if (metadata.belongId != space.id) {
      if (await removeMembers([user!.metadata])) {
        space.storages = space.storages.where((i) => i.key != key).toList();
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> delete({bool? notity = false}) async {
    final success = await super.delete(notity: notity);
    if (success) {
      space.storages = space.storages.where((i) => i.key != key).toList();
    }
    return success;
  }

  @override
  List<OperateModel> operates({int? mode}) {
    final operates = [...super.operates()];
    if (!isActivate) {
      operates.add(OperateModel.fromJson(TargetOperates.activate.toJson()));
    }
    return operates;
  }

  @override
  List<ITarget> get subTarget => [];

  @override
  List<ISession> get chats => [];

  @override
  List<ITarget> get targets => [this];

  @override
  bool get isActivate => id == space.metadata.storeId;

  @override
  Future<bool> activateStorage() async {
    if (!isActivate) {
      final res = await kernel.activateStorage(GainModel(
        id: id,
        subId: space.id,
      ));
      if (res.success) {
        space.updateMetadata<XEntity>(res.data!);
        space.sendTargetNotity(OperateType.update);
      }
      return res.success;
    }
    return false;
  }

  @override
  List<ITarget> content({int? mode}) => [];

  @override
  Future<void> deepLoad({bool? reload = false}) async {
    if (metadata.belongId == userId) {
      await loadMembers(reload: reload);
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
