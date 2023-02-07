import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';

import '../../base/schema.dart';
import '../enum.dart';
import 'itodo.dart';

class MarketJoinTodo extends ITodoGroup {
  final List<ApprovalItem> _todoList = [];
  final List<ApprovalItem> _doList = [];

  MarketJoinTodo(XMarket xMarket) {
    type = TodoType.marketTodo;
    id = xMarket.id;
    icon = xMarket.photo;
    name = xMarket.name;
  }

  @override
  Future<IApplyItemResult> getApplyList(PageRequest page) async {
    List<IApplyItem> applyList = [];
    final res = await KernelApi.getInstance()
        .queryJoinMarketApply(IDBelongReq(id: '', page: page));

    if (res.success!) {
      res.data?.result?.forEach((a) => {applyList.add(ApplyItem(a))});
    }
    return IApplyItemResult(
        applyList, res.data!.total, page.offset!, page.limit!);
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
      await getJoinApproval();
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
    await getJoinApproval();
    return _todoList;
  }

  getJoinApproval() async {
    final res = await KernelApi.getInstance().queryJoinApproval(IDBelongReq(
        id: id ?? '',
        page: PageRequest(offset: 0, limit: 2 ^ 16 - 1, filter: '')));
    if (res.success! && res.data!.result != null) {
      rePassFun(String id) {
        _doList.removeWhere((element) => element.getData().id == id);
      }
      passFun(String id) {
        _todoList.removeWhere((element) => element.getData().id == id);
      }

      _doList.clear();
      for (var element in res.data!.result!) {
        if (element.status >= CommonStatus.rejectStartStatus.value) {
          _doList.add(ApprovalItem(element, rePassFun, (data) {}));
        }
      }

      _todoList.clear();
      for (var element in res.data!.result!) {
        if (element.status == CommonStatus.applyStartStatus.value) {
          _todoList.add(ApprovalItem(element, passFun, (data) {
            _doList.add(ApprovalItem(data, rePassFun, (data) {}));
          }));
        }
      }
    }
  }
}

typedef PassCall = void Function(String id);
typedef RejectCall = void Function(XMarketRelation data);

class ApprovalItem extends IApprovalItem {
  final XMarketRelation _data;
  final PassCall _passCall;
  final RejectCall _rejectCall;

  getData() {
    return _data;
  }

  ApprovalItem(this._data, this._passCall, this._rejectCall);

  @override
  Future<bool> pass(int status, {String remark = ''}) async {
    final res = await KernelApi.getInstance()
        .approvalJoinApply(ApprovalModel(id: _data.id, status: status));
    if (res.success!) {
      _passCall.call(_data.id);
    }
    return res.success!;
  }

  @override
  Future<bool> reject(int status, String remark) async {
    final res = await KernelApi.getInstance()
        .approvalJoinApply(ApprovalModel(id: _data.id, status: status));
    if (res.success!) {
      _rejectCall.call(_data);
    }
    return res.success!;
  }
}

class ApplyItem extends IApplyItem {
  final XMarketRelation _data;

  getData() {
    return _data;
  }

  ApplyItem(this._data);

  @override
  Future<bool> cancel(int status, String remark) async {
    final res = await KernelApi.getInstance()
        .cancelJoinMarket(IdReqModel(id: _data.id, typeName: ''));
    return res.success!;
  }
}
