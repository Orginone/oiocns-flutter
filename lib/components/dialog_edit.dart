import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/unified_colors.dart';
import 'package:orginone/util/string_util.dart';

/// 编辑弹窗
typedef ConfirmCallback = void Function(BuildContext,String);

class DialogEdit extends Dialog {
  String? title; //标题
  String? content; //内容
  String? hint; //提示
  String confirmText; //是否需要"确定"按钮
  ConfirmCallback? confirmFun; //确定回调
  TextEditingController editingController = TextEditingController();

  DialogEdit(
      {Key? key,
      this.title,
      this.content,
      this.confirmText = "确定",
      this.hint = "请输入",
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
                    height: 76,
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: TextField(
                        maxLines: 3,
                        cursorColor: UnifiedColors.themeColor,
                        style: AFont.instance.size20Black3,
                        decoration: InputDecoration(
                            fillColor: UnifiedColors.bgGrayLight,
                            filled: true,
                            contentPadding: const EdgeInsets.all(12),
                            hintStyle: AFont.instance.size20Black9,
                            border: InputBorder.none,
                            hintText: StringUtil.formatStr(hint)),
                        controller: editingController,
                        keyboardType: TextInputType.text),
                  ),
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
                            textStyle: AFont.instance.size22Black3,
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
                                confirmFun!(context,
                                    editingController.text.toString().trim());
                              }
                            },
                            text: confirmText,
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
        style: const TextStyle(
            color: UnifiedColors.black3,
            fontSize: 16,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
