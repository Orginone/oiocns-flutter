import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';

import '../../base/schema.dart';
import '../enum.dart';
import 'itodo.dart';

class OrgTodo extends ITodoGroup {
  final List<ApprovalItem> _todoList = [];
  final List<ApprovalItem> _doList = [];
  final List<ApplyItem> _applyList = [];

  OrgTodo(String id, String name, String icon) {
    this.id = id;
    this.name = name;
    this.icon = icon;
    type = TodoType.orgTodo;
  }

  @override
  Future<IApplyItemResult> getApplyList(PageRequest page) async {
    final res = await KernelApi.getInstance()
        .queryJoinTeamApply(IDBelongReq(id: id ?? '', page: page));
    if (res.success! && res.data?.result != null) {
      _applyList.clear();
      for (var element in res.data!.result!) {
        _applyList.add(ApplyItem(element, (data) {
          _applyList.removeWhere((element) => element.getData().id == data.id);
        }));
      }
    }
    return IApplyItemResult(
        _applyList, res.data!.total, page.offset!, page.limit!);
  }

  @override
  Future<int> getCount() async {
    if (_todoList.isEmpty) {
      await getTodoList();
    }
    return _todoList.length;
  }

  @override
  Future<IApprovalItemResult> getDoList(PageRequest page) async {
    if (_doList.isEmpty) {
      await getApprovalList();
    }
    return IApprovalItemResult(
        _doList.sublist(page.offset!, page.offset! + page.limit!),
        _doList.length,
        page.offset!,
        page.limit!);
  }

  @override
  Future<List<IApprovalItem>> getNoticeList(bool refresh) {
    throw UnimplementedError();
  }

  @override
  Future<List<IApprovalItem>> getTodoList({bool refresh = false}) async {
    if (!refresh && _todoList.isNotEmpty) {
      return _todoList;
    }
    await getApprovalList();
    return _todoList;
  }

  getApprovalList() async {
    final res = await KernelApi.getInstance().queryTeamJoinApproval(IDBelongReq(
        id: id ?? '',
        page: PageRequest(offset: 0, limit: 2 ^ 16 - 1, filter: '')));

    if (res.success! && res.data!.result != null) {
      /// 同意回调
      passFun(XRelation s) {
        _todoList.removeWhere((element) => element.getData().id == s.id);
      }

      /// 已办中再次同意回调
      rePassFun(XRelation s) {
        _repassFun(s);
      }

      /// 拒绝回调
      rejectFun(XRelation s) {
        _doList.insert(
            0,
            ApprovalItem(s, (data) {
              _repassFun(data);
            }, (data) {}));
      }

      reRejectFun(XRelation s) {}

      List<ApprovalItem> temp = [];
      for (var element in res.data!.result!) {
        if (element.status >= CommonStatus.rejectStartStatus.value) {
          temp.add(ApprovalItem(element, rePassFun, reRejectFun));
        }
      }
      _doList.clear();
      _doList.addAll(temp);

      List<ApprovalItem> temp1 = [];
      for (var element in res.data!.result!) {
        if (element.status < CommonStatus.rejectStartStatus.value) {
          temp1.add(ApprovalItem(element, passFun, rejectFun));
        }
      }
      _todoList.clear();
      _todoList.addAll(temp1);
    }
  }

  _repassFun(XRelation xRelation) {
    _doList.removeWhere((element) => element.getData().id == xRelation.id);
  }
}

typedef ApprovalCall = void Function(XRelation data);

class ApprovalItem extends IApprovalItem {
  final XRelation _data;
  final ApprovalCall _passCall;
  final ApprovalCall _rejectCall;

  ApprovalItem(this._data, this._passCall, this._rejectCall);

  getData() {
    return _data;
  }

  @override
  Future<bool> pass(int status, {String remark = ''}) async {
    final res = await KernelApi.getInstance()
        .joinTeamApproval(ApprovalModel(id: _data.id, status: status));
    if (res.success!) {
      _passCall.call(_data);
    }
    return res.success!;
  }

  @override
  Future<bool> reject(int status, String remark) async {
    final res = await KernelApi.getInstance()
        .joinTeamApproval(ApprovalModel(id: _data.id, status: status));
    if (res.success!) {
      _rejectCall.call(_data);
    }
    return res.success!;
  }
}

class ApplyItem extends IApplyItem {
  final XRelation _data;
  final ApprovalCall _cancelFun;

  ApplyItem(this._data, this._cancelFun);

  getData() {
    return _data;
  }

  @override
  Future<bool> cancel(int status, String remark) async {
    final res = await KernelApi.getInstance()
        .cancelJoinTeam(IdReqModel(id: _data.id, typeName: ''));
    if (res.success!) {
      _cancelFun.call(_data);
    }
    return res.success!;
  }
}
