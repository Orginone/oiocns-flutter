import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/app/application.dart';
import 'package:orginone/dart/core/thing/market/market.dart';
import 'package:orginone/main.dart';

abstract class ICohort extends ITarget {
  //流通交易
  IMarket? get market;
}

class Cohort extends Target implements ICohort {
  Cohort(IBelong space, XTarget metadata)
      : super(metadata, [metadata.belong?.name ?? '', metadata.typeName],
            space: space){
    speciesTypes.add(SpeciesType.market);
  }

  @override
  IMarket? get market {
    try {
      final find = species.firstWhere(
        (i) => i.metadata.typeName == SpeciesType.market.label,
      );
      return find as IMarket?;
    } catch (e) {
      return null;
    }
  }

  @override
  // TODO: implement chats
  List<IMsgChat> get chats => [this];

  @override
  Future<void> deepLoad({bool reload = false}) async {
    await loadMembers(reload: reload);
    await loadSpecies(reload: reload);
  }

  @override
  Future<bool> delete() async {
    final res = await kernel.deleteTarget(IdReq(id: metadata.id));
    if (res.success) {
      space.cohorts.removeWhere((i) => i == this);
    }
    return res.success;
  }

  @override
  Future<bool> exit() async {
    if (metadata.belongId != space.metadata.id) {
      if (await removeMembers([space.user.metadata])) {
        space.cohorts.removeWhere((i) => i == this);
        return true;
      }
    }
    return false;
  }

  @override
  // TODO: implement subTarget
  List<ITarget> get subTarget => [];

  @override
  // TODO: implement workSpecies
  List<IApplication> get workSpecies {
    return species
        .where((a) => a.metadata.typeName == SpeciesType.application.label)
        .cast<IApplication>()
        .toList();
  }

  @override
  // TODO: implement targets
  List<ITarget> get targets => [this];
}
