import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';

import 'itodo.dart';

class PublishTodo extends ITodoGroup {
  final List<ApprovalItem> _doList = [];
  final List<ApplyItem> _applyList = [];
  final List<ApprovalItem> _todoList = [];

  PublishTodo(XMarket market) {
    id = market.id;
    icon = market.photo;
    name = market.name;
    type = TodoType.marketTodo;
  }

  @override
  Future<int> getCount() async {
    if (_todoList.isEmpty) {
      await getTodoList();
    }
    return _todoList.length;
  }

  @override
  Future<List<IApprovalItem>> getTodoList({bool refresh = false}) async {
    if (!refresh && _todoList.isNotEmpty) {
      return _todoList;
    }
    await getApprovalList();
    return _todoList;
  }

  @override
  Future<List<IApprovalItem>> getNoticeList(bool refresh) async {
    throw UnimplementedError();
  }

  @override
  Future<IApprovalItemResult> getDoList(PageRequest page) async {
    if (_doList.isEmpty) {
      await getApprovalList();
    }
    return IApprovalItemResult(
      _doList.sublist(page.offset, page.offset + page.limit),
      _doList.length,
      page.offset,
      page.limit,
    );
  }

  @override
  Future<IApplyItemResult> getApplyList(PageRequest page) async {
    final res = await KernelApi.getInstance()
        .queryMerchandiseApply(IDBelongReq(id: '', page: page));
    if (res.success && res.data?.result != null) {
      _applyList.clear();
      for (var element in res.data!.result!) {
        _applyList.add(ApplyItem(element, (id) {
          List<ApplyItem> temp = [];
          //TODO:其他地方的
          _applyList.removeWhere((el) => el._data.id == id);
        }));
      }
    }
    return IApplyItemResult(
        _applyList, res.data!.total, page.offset, page.limit);
  }

  getApprovalList() async {
    final res = await KernelApi.getInstance().queryPublicApproval(IDBelongReq(
        id: id ?? '',
        page: PageRequest(offset: 0, limit: 2 ^ 16 - 1, filter: '')));

    if (res.success && res.data?.result != null) {
      // 同意回调
      passFun(String id) {
        _todoList.removeWhere((element) => element._data.id == id);
      }

      // 已办中再次同意回调
      rePassFun(String id) {
        _doList.removeWhere((element) => element._data.id == id);
      }

      // 拒绝回调
      rejectFun(XMerchandise s) {
        _doList.insert(0, ApprovalItem(s, rePassFun, (_) {}));
      }

      reRejectFun(XMerchandise _) {}
      _doList.clear();
      for (var element in res.data!.result!) {
        if (element.status >= CommonStatus.rejectStartStatus.value) {
          _doList.add(ApprovalItem(element, rePassFun, reRejectFun));
        }
      }

      _todoList.clear();
      for (var element in res.data!.result!) {
        if (element.status < CommonStatus.rejectStartStatus.value) {
          _todoList.add(ApprovalItem(element, passFun, rejectFun));
        }
      }
    }
  }
}

typedef ApprovalCall = void Function(String id);
typedef RejectCall = void Function(XMerchandise x);

class ApprovalItem extends IApprovalItem {
  final XMerchandise _data;
  final ApprovalCall _passCall;
  final RejectCall _rejectCall;

  getData() {
    return _data;
  }

  ApprovalItem(this._data, this._passCall, this._rejectCall);

  @override
  Future<bool> pass(int status, {String remark = ''}) async {
    final res = await KernelApi.getInstance()
        .approvalMerchandise(ApprovalModel(id: _data.id, status: status));
    if (res.success) {
      _passCall.call(_data.id);
    }
    return res.success;
  }

  @override
  Future<bool> reject(int status, String remark) async {
    final res = await KernelApi.getInstance()
        .approvalMerchandise(ApprovalModel(id: _data.id, status: status));
    if (res.success) {
      _rejectCall.call(_data);
    }
    return res.success;
  }
}

typedef ApplyCall = void Function(String id);

class ApplyItem implements IApplyItem {
  final XMerchandise _data;
  final ApplyCall _cancelCall;

  ApplyItem(this._data, this._cancelCall);

  @override
  Future<bool> cancel(int status, String remark) async {
    final res = await KernelApi.getInstance()
        .deleteMerchandise(IDWithBelongReq(id: _data.id, belongId: ''));
    if (res.success) {
      _cancelCall.call(_data.id);
    }
    return res.success;
  }

  @override
  get data => _data;

  @override
  set data(d) {}
}
