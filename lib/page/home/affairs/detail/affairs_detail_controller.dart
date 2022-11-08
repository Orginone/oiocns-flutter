import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/page/home/affairs/affairs_type_enum.dart';
import 'package:orginone/public/http/base_controller.dart';
import '../../../../api/workflow_api.dart';
import '../../../../public/loading/opt_loading.dart';
import '../../../../util/string_util.dart';
import '../base/detail_arguments.dart';

class AffairsDetailController extends BaseController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  late DetailArguments arguments;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void approvalTask(bool isAgree,String content) async {
    String id;
    if (arguments.typeEnum == AffairsTypeEnum.record) {
      id = "";
    } else if (arguments.typeEnum == AffairsTypeEnum.instance) {
      id = "";
    } else {
      id = StringUtil.formatStr(arguments.taskEntity?.id);
    }
    ALoading.showCircle();
    /// 201 拒绝 101 同意
    String status = isAgree ? "101" : "201";
    await WorkflowApi.approvalTask(id, status, content).then((value) {
      /// 审核成功，刷新页面
    }).onError((error, stackTrace) {
      /// 成功则通知列表刷新
      Fluttertoast.showToast(msg: error.toString());
    }).whenComplete(() => ALoading.dismiss());
  }

  String getTitle() {
    debugPrint("------刷新了");
    if (arguments.typeEnum == AffairsTypeEnum.record) {
      return StringUtil.formatStr(
          arguments.recordEntity?.flowTask?.flowInstance?.title);
    } else if (arguments.typeEnum == AffairsTypeEnum.instance) {
      return StringUtil.formatStr(arguments.instanceEntity?.title);
    } else {
      /// 待办和抄送
      return StringUtil.formatStr(arguments.taskEntity?.flowInstance?.title);
    }
  }

  String getFunctionCode() {
    if (arguments.typeEnum == AffairsTypeEnum.record) {
      return arguments.recordEntity?.flowTask?.flowInstance?.flowRelation
              ?.functionCode ??
          "";
    } else if (arguments.typeEnum == AffairsTypeEnum.instance) {
      return arguments.instanceEntity?.flowRelation?.functionCode ?? "";
    } else {
      /// 待办和抄送
      return StringUtil.formatStr(
          arguments.taskEntity?.flowInstance?.flowRelation?.functionCode);
    }
  }

  getContent() {
    if (arguments.typeEnum == AffairsTypeEnum.record) {
      return arguments.recordEntity?.flowTask?.flowInstance?.content ?? "";
    } else if (arguments.typeEnum == AffairsTypeEnum.instance) {
      return arguments.instanceEntity?.content;
    } else {
      /// 待办和抄送
      return arguments.taskEntity?.flowInstance?.content ?? "";
    }
  }

  getTime() {
    if (arguments.typeEnum == AffairsTypeEnum.record) {
      return arguments.recordEntity?.createTime ?? "";
    } else if (arguments.typeEnum == AffairsTypeEnum.instance) {
      return arguments.instanceEntity?.createTime ?? "";
    } else {
      /// 待办和抄送
      return StringUtil.formatStr(arguments.taskEntity?.createTime);
    }
  }

  String getStatus() {
    if (arguments.typeEnum == AffairsTypeEnum.record) {
      if (arguments.recordEntity!.status >= 0 &&
          arguments.recordEntity!.status < 100) {
        return '待批';
      } else if (arguments.recordEntity!.status <= 200) {
        return '已通过';
      } else {
        return '已拒绝';
      }
    } else if (arguments.typeEnum == AffairsTypeEnum.instance) {
      if (arguments.instanceEntity!.status >= 0 &&
          arguments.instanceEntity!.status < 100) {
        return '待批';
      } else if (arguments.instanceEntity!.status <= 200) {
        return '已通过';
      } else {
        return '已拒绝';
      }
    } else {
      /// 待办和抄送
      return arguments.taskEntity!.status >= 0 &&
              arguments.taskEntity!.status < 100
          ? '待批'
          : '已通过';
    }
  }
}
