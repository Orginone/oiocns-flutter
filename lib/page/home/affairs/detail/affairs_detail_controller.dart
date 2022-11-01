import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/page/home/affairs/affairs_type_enum.dart';
import 'package:orginone/public/http/base_controller.dart';

import '../../../../api/workflow_api.dart';
import '../../../../api_resp/task_entity.dart';
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

  void approvalTask(String content) async {
    String id;
    if (arguments.typeEnum == AffairsTypeEnum.record) {
      id = "";
    } else if (arguments.typeEnum == AffairsTypeEnum.instance) {
      id = "";
    } else {
      id = StringUtil.formatStr(arguments.taskEntity?.id);
    }

    var pageResp =
        await WorkflowApi.approvalTask(id, '201', content, (error) {
          Fluttertoast.showToast(msg: "err:$error");
        });

  }

  String getTitle() {
    if (arguments.typeEnum == AffairsTypeEnum.record) {
      return "";
    } else if (arguments.typeEnum == AffairsTypeEnum.instance) {
      return "";
    } else {
      /// 待办和抄送
      return StringUtil.formatStr(arguments.taskEntity?.flowInstance?.title);
    }
  }

  String getFunctionCode() {
    if (arguments.typeEnum == AffairsTypeEnum.record) {
      return "";
    } else if (arguments.typeEnum == AffairsTypeEnum.instance) {
      return "";
    } else {
      /// 待办和抄送
      return StringUtil.formatStr(
          arguments.taskEntity?.flowInstance?.flowRelation?.functionCode);
    }
  }

  getContent() {
    if (arguments.typeEnum == AffairsTypeEnum.record) {
      return "";
    } else if (arguments.typeEnum == AffairsTypeEnum.instance) {
      return "";
    } else {
      /// 待办和抄送
      return StringUtil.formatStr(
          arguments.taskEntity?.flowInstance?.flowRelation?.functionCode);
    }
  }

  getTime() {
    if (arguments.typeEnum == AffairsTypeEnum.record) {
      return "";
    } else if (arguments.typeEnum == AffairsTypeEnum.instance) {
      return "";
    } else {
      /// 待办和抄送
      return StringUtil.formatStr(arguments.taskEntity?.createTime);
    }
  }

  String getStatus() {
    if (arguments.typeEnum == AffairsTypeEnum.record) {
      return "";
    } else if (arguments.typeEnum == AffairsTypeEnum.instance) {
      return "";
    } else {
      /// 待办和抄送
      return arguments.taskEntity!.status >= 0 &&
              arguments.taskEntity!.status < 100
          ? '待批'
          : '已通过';
    }
  }
}
