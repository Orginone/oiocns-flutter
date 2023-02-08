import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';

import '../../base/schema.dart';
import '../enum.dart';
import 'itodo.dart';

class OrderTodo extends ITodoGroup {
  @override
  String? get name => "订单审批";
  final List<ApprovalItem> _todoList = [];
  final List<ApprovalItem> _doList = [];

  @override
  Future<IApplyItemResult> getApplyList(PageRequest page) async {
    List<IOrderApplyItem> applyList = [];

    final res = await KernelApi.getInstance()
        .queryBuyOrderList(IDStatusPageReq(id: '', status: 0, page: page));

    if (res.success! && res.data?.result != null) {
      for (var element in res.data!.result!) {
        applyList.add(OrderApplyItem(element));
      }
    }
    return IApplyItemResult(
        applyList, res.data!.total, page.offset!, page.limit!);
  }

  @override
  Future<int> getCount() async {
    if (_todoList.isEmpty) {
      await getTodoList();
    }
    return _todoList.length - _doList.length;
  }

  @override
  Future<IApprovalItemResult> getDoList(PageRequest page) async {
    if (_doList.isEmpty) {
      await getApprovalList();
    }
    return IApprovalItemResult(_doList.sublist(page.offset!,page.offset! + page.limit!),
        _doList.length, page.offset!, page.limit!);
  }

  @override
  Future<List<IApprovalItem>> getNoticeList(bool refresh) {
    throw UnimplementedError();
  }

  @override
  Future<List<IApprovalItem>> getTodoList({bool refresh = false}) async {
    if (refresh || _todoList.isEmpty) {
      await getApprovalList();
    }
    return _todoList;
  }

  getApprovalList() async {
    final res = await KernelApi.getInstance().querySellOrderList(
        IDStatusPageReq(
            status: 0,
            id: '',
            page: PageRequest(offset: 0, limit: 2 ^ 16 - 1, filter: '')));

    if (res.success! && res.data!.result != null) {
      // 同意回调
      approvalCall(XOrderDetail data) {
        _todoList.removeWhere((element) => element.getData().id == data.id);
        _doList.insert(0, ApprovalItem(data, (data) {}));
      }

      List<ApprovalItem> temp = [];
      for (var element in res.data!.result!) {
        if (element.status >= CommonStatus.approveStartStatus.value) {
          temp.add(ApprovalItem(element, (data) {}));
        }
      }
      _doList.clear();
      _doList.addAll(temp);

      _todoList.clear();
      res.data!.result!.sort((a, b) => (b.status).compareTo(a.status));
      for (var element in res.data!.result!) {
        _todoList.add(ApprovalItem(element, approvalCall));
      }
    }
  }
}

typedef ApprovalCall = void Function(XOrderDetail data);

class ApprovalItem extends IApprovalItem {
  final XOrderDetail _data;
  final ApprovalCall? _approvalCall;

  getData() {
    return _data;
  }

  ApprovalItem(this._data, this._approvalCall);

  @override
  Future<bool> pass(int status, {String remark = ''}) async {
    final res = await KernelApi.getInstance()
        .deliverMerchandise(ApprovalModel(id: _data.id, status: status));
    if (res.success!) {
      _approvalCall?.call(_data);
    }
    return res.success!;
  }

  @override
  Future<bool> reject(int status, String remark) async {
    final res = await KernelApi.getInstance().cancelOrderDetail(ApprovalModel(
      id: _data.id,
      status: status,
    ));
    if (res.success!) {
      _approvalCall?.call(_data);
    }
    return res.success!;
  }
}

class OrderApplyItem extends IOrderApplyItem {
  final XOrder _data;

  getData() {
    return _data;
  }

  OrderApplyItem(this._data);

  @override
  Future<bool> cancel(int status, String remark) async {
    return (await KernelApi.getInstance()
            .cancelOrder(ApprovalModel(id: _data.id, status: status)))
        .success!;
  }

  @override
  Future<bool> cancelItem(String id, int status, String remark) async {
    XOrderDetail? detail;
    _data.details?.forEach((element) {
      if (element.id == id) {
        detail = element;
      }
    });
    if (detail != null) {
      late ResultType<bool> res;
      if (detail!.status > CommonStatus.approveStartStatus.value) {
        res = await KernelApi.getInstance()
            .rejectMerchandise(ApprovalModel(id: _data.id, status: status));
        if (res.success!) {
          detail!.status = status;
          return true;
        }
      } else {
        res = await KernelApi.getInstance()
            .cancelOrderDetail(ApprovalModel(id: _data.id, status: status));
        if (res.success!) {
          detail!.status = status;
          return true;
        }
      }
    }
    return false;
  }

  @override
  Future<bool> reject(String id, int status, String remark) async {
    return (await KernelApi.getInstance()
            .rejectMerchandise(ApprovalModel(id: id, status: status)))
        .success!;
  }
}
