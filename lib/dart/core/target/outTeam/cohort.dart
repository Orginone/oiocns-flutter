import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';

abstract class ICohort extends ITarget {}

/// 群组
class Cohort extends Target implements ICohort {
  Cohort(this.metadata, this.space, this.relationId)
      : super(
          [space!.key],
          metadata,
          [relationId],
          space: space,
          user: space.user,
        );

  @override
  XTarget metadata;
  @override
  late IBelong? space;
  @override
  String relationId;

  @override
  Future<bool> exit() async {
    if (metadata.belongId != space?.metadata.id) {
      if (await removeMembers(
          space?.user?.metadata != null ? [space!.user!.metadata] : [])) {
        space?.cohorts.removeWhere((i) => i == this);
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> delete({bool? notity}) async {
    final success = await super.delete(notity: notity);
    if (success) {
      space?.cohorts.removeWhere((i) => i == this);
    }
    return success;
  }

  @override
  List<ITarget> get subTarget => [];
  @override
  List<ISession> get chats => targets.map((i) => i.session).toList();
  @override
  List<ITarget> get targets => [this];

  @override
  Future<void> deepLoad({bool? reload = false}) async {
    await Future.wait([
      loadMembers(reload: reload),
      directory.loadDirectoryResource(reload: reload)
    ]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
