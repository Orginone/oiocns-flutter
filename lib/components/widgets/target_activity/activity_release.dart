import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/base/model.dart' hide Column;
import 'package:orginone/dart/core/chat/activity.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/utils/load_image.dart';
import 'package:orginone/utils/toast_utils.dart';

///发布动态
class ActivityRelease extends OrginoneStatefulWidget<IActivity> {
  ActivityRelease({super.key});
  @override
  State<StatefulWidget> createState() => _ActivityReleaseState();
}

class _ActivityReleaseState
    extends OrginoneStatefulState<ActivityRelease, IActivity> {
  late TextEditingController _inputController;
  late List<FileItemShare> _resources;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
    _resources = [];
  }

  @override
  Widget buildWidget(BuildContext context, IActivity data) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputBox(context, data),
          _buildResource(context, data),
        ],
      ),
    );
  }

  ///构建文本输入框
  Widget _buildInputBox(BuildContext context, IActivity data) {
    return TextField(
      key: GlobalKey(),
      controller: _inputController,
      scrollPhysics: const ScrollPhysics(),
      minLines: 5,
      maxLines: 10,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: '写下点什么吧....', // 这里设置默认的提示文本
      ),
    );
  }

  ///上传资源
  Widget _buildResource(BuildContext context, IActivity data) {
    return GestureDetector(
      onTap: () {
        ToastUtils.showMsg(msg: "敬请期待");
      },
      child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
          child: XImage.localImage(XImage.add, width: 80)),
    );
  }

  @override
  List<Widget>? buildButtons(BuildContext context, IActivity data) {
    return [
      GestureDetector(
        onTap: () async {
          LoadingDialog.showLoading(context, msg: "评论发表中");
          if (await _sendActivity(data)) {
            LoadingDialog.dismiss(context);
            Get.back();
          }
        },
        child: Text(
          "发表",
          style: TextStyle(color: XColors.themeColor, fontSize: 20.sp),
        ),
      )
    ];
  }

  Future<bool> _sendActivity(IActivity data) async {
    return await data
        .send(_inputController.text, MessageType.text, _resources, []);
  }
}
