import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';

import '../../base/schema.dart';
import '../enum.dart';
import 'itodo.dart';

class ApplicationTodo extends ITodoGroup {
  final String _id;
  final String _name;
  final List<ApprovalItem> _todoList = [];
  final List<NoticeItem> _noticeList = [];

  getName() {
    return _name;
  }

  getId() {
    return _id;
  }

  ApplicationTodo(this._id, this._name) {
    type = TodoType.applicationTodo;
  }

  @override
  Future<IApplyItemResult> getApplyList(PageRequest page) async {
    List<IApplyItem> applyList = [];
    var res = await KernelApi.getInstance().queryJoinMarketApply(
        IDBelongReq(id: '', page: page));
    if (res.success == true) {
      res.data?.result?.forEach((element) {
        applyList.add(ApplyItem(element));
      });
    }
    return IApplyItemResult(
        applyList, (res.data?.total ?? 0) > 1 ? res.data!.total : 0,
        page.offset!, page.limit!);
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
    List<IApprovalItem> completeList = [];
    //spaceId可以不传
    var res = await KernelApi.getInstance().queryRecord(
        IdSpaceReq(id: _id, spaceId: '', page: page));
    if (res.success!) {
      res.data?.result?.forEach((element) {
        completeList.add(CompleteItem(element));
      });
    }
    return IApprovalItemResult(
        completeList, (res.data?.total ?? 0) > 0 ? res.data!.total : 0,
        page.offset!, page.limit!);
  }

  @override
  Future<List<IApprovalItem>> getNoticeList(bool refresh) async {
    if (!refresh && _noticeList.isNotEmpty) {
      return _noticeList;
    }
    var res = await KernelApi.getInstance().queryNoticeTask(IdReq(id: _id));
    if (res.success == true && res.data != null && res.data!.result != null) {
      for (var element in res.data!.result!) {
        _noticeList.add(NoticeItem(element, (id) =>{
          _noticeList.removeWhere((element) => element.getData().id == id)
        }));
      }
    }
    return _noticeList;
  }

  @override
  Future<List<IApprovalItem>> getTodoList({bool refresh = false}) async {
    if (!refresh && _todoList.isNotEmpty) {
      return _todoList;
    }
    var res = await KernelApi.getInstance().queryApproveTask(IdReq(id: _id));
    if (res.success == true && res.data != null && res.data!.result != null) {
      for (var element in res.data!.result!) {
        _todoList.add(ApprovalItem(element, (id) =>{
          _todoList.removeWhere((element) => element.getData().id == id)
        }));
      }
    }
    return _todoList;
  }

}


typedef CompleteFun = Function(String id);

class ApprovalItem extends IApprovalItem {
  final XFlowTask _data;
  final CompleteFun _completeFun;

  ApprovalItem(this._data, this._completeFun);

  getData() {
    return _data;
  }

  @override
  Future<bool> pass(int status, {String remark = ''}) async {
    var res = await KernelApi.getInstance().approvalTask(
        ApprovalTaskReq(id: _data.id, status: status, comment: remark));
    if (res.success == true) {
      _completeFun.call(_data.id);
    }
    return res.success == true;
  }

  @override
  Future<bool> reject(int status, String remark) async {
    var res = await KernelApi.getInstance().approvalTask(
        ApprovalTaskReq(id: _data.id, status: status, comment: remark));
    if (res.success == true) {
      _completeFun.call(_data.id);
    }
    return res.success == true;
  }

}

typedef NoticeCall = Function(String id);

class NoticeItem extends IApprovalItem {
  final XFlowTaskHistory _data;
  NoticeCall passCall;

  getData(){
    return _data;
  }

  NoticeItem(this._data, this.passCall);

  @override
  Future<bool> pass(int status, {String remark = ''}) async {
    var res = await KernelApi.getInstance().approvalTask(
        ApprovalTaskReq(id: _data.id, status: status, comment: remark));
    if (res.success == true) {
      passCall.call(_data.id);
    }
    return res.success == true;
  }

  @override
  Future<bool> reject(int status, String remark) {
    throw UnimplementedError();
  }
}

class CompleteItem extends IApprovalItem {
  final XFlowTaskHistory _data;

  CompleteItem(this._data);

  getData() {
    return _data;
  }

  @override
  Future<bool> pass(int status, {String remark = ''}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> reject(int status, String remark) {
    throw UnimplementedError();
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
    final res = await KernelApi.getInstance().cancelJoinMarket(
        IdReqModel(id: _data.id, typeName: ''));
    return res.success == true;
  }
}
