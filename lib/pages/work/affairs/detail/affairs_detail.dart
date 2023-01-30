import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/base_view.dart';
import 'package:orginone/components/dialog_edit.dart';
import 'package:orginone/components/form_text_space_between.dart';
import 'package:orginone/components/load_status.dart';
import 'package:orginone/components/unified_colors.dart';
import 'package:orginone/pages/work/affairs/affairs_type_enum.dart';
import 'package:orginone/pages/work/affairs/base/detail_arguments.dart';
import 'package:orginone/pages/work/affairs/detail/affairs_detail_controller.dart';

class AffairsDetailPage extends BaseView<AffairsDetailController> {
  late DetailArguments arguments;

  AffairsDetailPage({super.key}) {
    arguments = Get.arguments as DetailArguments;
    controller.arguments = arguments;
  }

  late BuildContext context;

  @override
  LoadStatusX initStatus() {
    return LoadStatusX.success;
  }

  @override
  String getTitle() {
    return "详情";
  }

  @override
  bool isUseScaffold() {
    return true;
  }

  @override
  Widget builder(context) {
    debugPrint('----刷新了');
    this.context = context;
    return Column(
      children: [
        _tabBar(),
        _tabBarView(),
        Divider(
          height: 2.h,
          color: UnifiedColors.lineLight,
        ),
        _bottom()
      ],
    );
  }

  bool _isBottomOptShow() {
    return arguments.typeEnum == AffairsTypeEnum.task;
  }

  _tabBar() {
    return Container(
      color: UnifiedColors.white,
      child: TabBar(
        isScrollable: false,
        controller: controller.tabController,
        labelColor: UnifiedColors.themeColor,
        unselectedLabelColor: UnifiedColors.black6,
        indicatorColor: UnifiedColors.themeColor,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(fontSize: 20.sp),
        tabs: const [
          Tab(text: '审批内容'),
          Tab(text: '流程进度'),
        ],
      ),
    );
  }

  _tabBarView() {
    return Expanded(
      flex: 1,
      child: TabBarView(
        controller: controller.tabController,
        children: [
          _content(),
          _flow(),
        ],
      ),
    );
  }

  _content() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          FutureBuilder<String>(
            future: controller.getAppName(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return TextSpaceBetween(
                leftTxt: '应用名',
                rightTxt: snapshot.data ?? "",
              );
            },
          ),
          TextSpaceBetween(
            leftTxt: '流程名称',
            rightTxt: controller.getTitle(),
          ),
          TextSpaceBetween(
            leftTxt: '业务名称',
            rightTxt: controller.getFunctionCode(),
          ),
          TextSpaceBetween(
            leftTxt: '申请人',
            rightTxt: controller.getApplicant(),
          ),
          TextSpaceBetween(
            leftTxt: '内容',
            rightTxt: controller.getContent(),
          ),
          TextSpaceBetween(
            leftTxt: '状态',
            rightTxt: controller.getStatus(),
          ),
          TextSpaceBetween(
            leftTxt: '发送时间',
            rightTxt: controller.getTime(),
          ),
        ],
      ),
    );
  }

  _flow() {
    return Container(
      color: Colors.green,
    );
  }

  _bottom() {
    return Visibility(
        visible: _isBottomOptShow(),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: GFButton(
                  color: UnifiedColors.white,
                  onPressed: () {
                    showAnimatedDialog(
                      context: context,
                      barrierDismissible: false,
                      animationType: DialogTransitionType.fadeScale,
                      builder: (BuildContext context) {
                        return DialogEdit(
                          title: "审批信息",
                          content: "",
                          confirmFun: (context, content) {
                            Navigator.of(context).pop();
                            controller.approvalTask(false, content);
                          },
                        );
                      },
                    );
                  },
                  text: "拒绝",
                  textStyle: AFont.instance.size22themeColorW500,
                )),
            Container(
              width: 2.w,
              height: 30.h,
              color: UnifiedColors.lineLight,
            ),
            Expanded(
                flex: 1,
                child: GFButton(
                  color: UnifiedColors.white,
                  onPressed: () {
                    showAnimatedDialog(
                      context: context,
                      barrierDismissible: false,
                      animationType: DialogTransitionType.fadeScale,
                      builder: (BuildContext context) {
                        return DialogEdit(
                          title: "审批信息",
                          content: "",
                          confirmFun: (context, content) {
                            Navigator.of(context).pop();
                            controller.approvalTask(true, content);
                          },
                        );
                      },
                    );
                  },
                  text: "同意",
                  textStyle: AFont.instance.size22themeColorW500,
                  textColor: UnifiedColors.themeColor,
                )),
          ],
        ));
  }
}
