import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:orginone/widget/a_font.dart';
import 'package:orginone/widget/base_controller.dart';
import 'package:orginone/widget/template/originone_scaffold.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/util/string_util.dart';
import 'package:orginone/util/widget_util.dart';

class TodoDetail extends StatefulWidget {
  const TodoDetail({Key? key}) : super(key: key);

  @override
  State<TodoDetail> createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return OrginoneScaffold(
        appBarCenterTitle: true,
        appBarTitle: Text(
          "详情",
          style: AFont.instance.size22Black3,
        ),
        appBarLeading: WidgetUtil.defaultBackBtn,
        bgColor: XColors.white,
        body: _content(),
        resizeToAvoidBottomInset: false);
  }


  _content() {
    return Container(
      color: XColors.bgColor,
      child: ListView(
        children: [
          Container(
            color: XColors.white,
            padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "办事信息",
                  style: AFont.instance.size22Black3,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  color: XColors.backColor,
                  height: 60.h,
                )
              ],
            ),
          ),
          Container(
            color: XColors.white,
            margin: EdgeInsets.only(top: 20.h),
            padding: EdgeInsets.only(left: 20.w, top: 15.h, right: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "办事流程",
                  style: AFont.instance.size22Black3,
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextSpaceBetween(
                  leftTxt: '申请人',
                  rightTxt: "controller.getTitle()",
                ),
                TextSpaceBetween(
                  leftTxt: '申请时间',
                  rightTxt: "controller.getTitle()",
                ),
                TextSpaceBetween(
                  leftTxt: '资产类型',
                  rightTxt: "controller.getTitle()",
                ),
                TextSpaceBetween(
                  leftTxt: '申请说明',
                  rightTxt: "controller.getTitle()",
                ),
                TextSpaceBetween(
                  leftTxt: '截止时间',
                  rightTxt: "controller.getTitle()",
                ),
                TextSpaceBetween(
                  leftTxt: '办事类型',
                  rightTxt: "controller.getTitle()",
                ),
              ],
            ),
          ),
          Container(
              color: XColors.white,
              margin: EdgeInsets.only(top: 20.h),
              padding: EdgeInsets.only(left: 20.w, top: 15.h, right: 10.w,bottom: 15.h),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "意见填写",
                      style: AFont.instance.size22Black3,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                      child: TextField(
                          maxLines: 3,
                          cursorColor: XColors.themeColor,
                          style: AFont.instance.size20Black3,
                          decoration: InputDecoration(
                              fillColor: XColors.bgGrayLight,
                              filled: true,
                              contentPadding: const EdgeInsets.all(12),
                              hintStyle: AFont.instance.size20Black9,
                              border: InputBorder.none,
                              hintText: StringUtil.formatStr('')),
                          controller: _editingController,
                          keyboardType: TextInputType.text),
                    )
                  ])),
          SizedBox(height: 80.h,),
          _bottom()
        ],
      ),
    );
  }
  _bottom() {
    return Visibility(
        visible: true,
        child: Column(
          children: [
            SizedBox(
              width: 300.w,
              height: 70.h,
              child: GFButton(
                color: XColors.themeColor,
                onPressed: () {
                  //TODO:start测试代码
                  /*controller.getFriends();
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
                  );*/
                },
                text: "同意",
                textStyle: AFont.instance.size22WhiteW500,
                textColor: XColors.themeColor,
              ),
            ),
            SizedBox(height: 15.h,),
            SizedBox(
              height: 70.h,
              width: 300.w,
              child: GFButton(
                size: GFSize.LARGE,
                color: XColors.fontErrorColor,
                onPressed: () {
                  /*showAnimatedDialog(
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
                  );*/
                },
                text: "拒绝",
                textStyle: AFont.instance.size22WhiteW500,
              ),
            ),
            SizedBox(height: 40.h,),
          ],
        ));
  }
}

/// 横排 两端对齐的item
class TextSpaceBetween extends StatelessWidget {
  final String leftTxt;
  final String rightTxt;
  final bool isShowLine;
  final TextStyle leftStyle;
  final TextStyle rightStyle;

  const TextSpaceBetween({
    Key? key,
    this.leftTxt = '',
    this.rightTxt = '',
    this.isShowLine = false,
    this.leftStyle =  const TextStyle(color: XColors.black3, fontSize: 16),
    this.rightStyle =
    const TextStyle(color: XColors.black6, fontSize: 16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 15, 12, 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          leftTxt,
                          style: leftStyle,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(rightTxt, style: rightStyle)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12, right: 12),
                child: Divider(
                  height: 2,
                  color: XColors.lineLight,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}


class TodoDetailController extends BaseController{

}

class TodoDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TodoDetailController());
  }
}