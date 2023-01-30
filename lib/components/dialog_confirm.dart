import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/unified_colors.dart';

/// 确认弹窗
typedef ConfirmCallback = void Function();

class DialogConfirm extends Dialog {
  String? title; //标题
  String? content; //内容
  String confirmText; //是否需要"确定"按钮
  ConfirmCallback? confirmFun; //确定回调

  DialogConfirm(
      {Key? key,
      this.title,
      this.content,
      this.confirmText = "确定",
      this.confirmFun});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 100),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _title(),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 18, 0, 18),
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: Text(
                        content == null ? "" : content!,
                        style: const TextStyle(
                            fontSize: 14, color: UnifiedColors.black3),
                      )),
                  const Divider(
                    color: UnifiedColors.lineLight,
                    height: 2,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: GFButton(
                            color: UnifiedColors.white,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            text: "取消",
                            textStyle: AFont.instance.size22Black9,
                          )),
                      Container(
                        width: 1.5.w,
                        height: 30.h,
                        color: UnifiedColors.lineLight,
                      ),
                      Expanded(
                          flex: 1,
                          child: GFButton(
                            color: UnifiedColors.white,
                            onPressed: () {
                              if (confirmFun == null) {
                                Navigator.of(context).pop();
                              } else {
                                confirmFun!();
                              }
                            },
                            text: "确定",
                            textStyle: AFont.instance.size22Black3,
                            textColor: UnifiedColors.themeColor,
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _title() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Text(
        "$title",
        style: AFont.instance.size22Black3W500,
      ),
    );
  }
}
