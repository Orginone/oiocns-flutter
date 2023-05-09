import '../../base/schema.dart';
import '../enum.dart';
import 'base.dart';
import 'itarget.dart';

/*
 * 工作组的元操作
 */
class Working extends BaseTarget implements IWorking {
  final Function _onDeleted;
  Working(XTarget target, ISpace? space, String userId, this._onDeleted) : super(target, space, userId);
  @override
  Future<bool> delete() async {
    final res = await deleteTarget();
    if (res.success) {
      _onDeleted(this, []);
    }
    return res.success;
  }

  @override
  Future<XTargetArray> searchPerson(String code) async {
    return await searchTargetByName(code, [TargetType.person]);
  }
}
