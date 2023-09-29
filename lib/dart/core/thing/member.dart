import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/operates.dart';

import './directory.dart';
import './fileinfo.dart';

abstract class IMember implements IFileInfo<XTarget> {
  late bool isMember;
  late String fullId;
}

class Member extends FileInfo<XTarget> implements IMember {
  Member(
    XTarget metadata,
    IDirectory directory,
  ) : super(metadata, directory);

  @override
  bool isMember = true;

  @override
  String get cacheFlag => 'members';

  @override
  String get fullId => '${directory.belongId}-${metadata.id}';

  @override
  Future<bool> rename(String name) async {
    throw Exception('Not supported yet.');
  }

  @override
  Future<bool> copy(IDirectory destination) async {
    await destination.target.pullMembers([metadata]);
    return true;
  }

  @override
  Future<bool> move(IDirectory destination) async {
    throw Exception('Not supported yet.');
  }

  @override
  Future<bool> delete() async {
    throw Exception('Not supported yet.');
  }

  @override
  List<OperateModel> operates({int? mode}) {
    final operates = super.operates(mode: 1);
    if (metadata.id != directory.belongId &&
        directory.target.hasRelationAuth()) {
      operates.insert(0, OperateModel.fromJson(MemberOperates.copy.toJson()));
      operates.insert(0, OperateModel.fromJson(MemberOperates.remove.toJson()));
    }
    if (metadata.id != directory.target.userId) {
      operates.insert(0, OperateModel.fromJson(TargetOperates.chat.toJson()));
    }
    return operates;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
