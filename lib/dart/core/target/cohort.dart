import '../../base/schema.dart';
import '../enum.dart';
import 'base.dart';
import 'itarget.dart';

class Cohort extends BaseTarget implements ICohort {
  final Function _onDeleted;
  Cohort(XTarget target, this._onDeleted) : super(target) {
    searchTargetType = [TargetType.person];
    subTeamTypes = [];
  }
  @override
  Future<XTargetArray> searchPerson(String code) async {
    return await searchTargetByName(code, [TargetType.person]);
  }

  @override
  Future<bool> delete() async {
    final res = await deleteTarget();
    if (res.success) {
      _onDeleted(this, []);
    }
    return res.success;
  }
}
