import 'package:flutter/material.dart';

//组件布局组件字段 顺序是从左到右
class FormItemType1 extends StatelessWidget {
  //背景
  final Color? bgColor;
  //最左侧的插槽
  final Widget? leftSlot;
  //左上标题
  final String? title;
  //左下文本
  final String? text;
  //最右侧图标
  final Icon? suffixIcon;
  //全局的点击事件
  final Function? callback1;
  //最右侧图标的点击事件
  final Function? callback2;

  const FormItemType1({
    Key? key,
    this.bgColor = Colors.white,
    this.callback1,
    this.callback2,
    this.title,
    this.text,
    this.leftSlot,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
          color: bgColor,
          child: InkWell(
        onTap: () {
          callback1 != null ? callback1!() : () => {};
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  leftSlot != null
                      ? Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: leftSlot,
                        )
                      : Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: Text(title ?? '',
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(130, 130, 130, 1))),
                      ),
                      Text(text ?? '', style: const TextStyle(fontSize: 16)),
                    ],
                  )),
                  suffixIcon != null
                      ? IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          iconSize: 18,
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          constraints: const BoxConstraints(
                              minHeight: 30, maxHeight: 30),
                          onPressed: () {
                            callback2 != null ? callback2!() : () => {};
                          },
                          icon: suffixIcon!)
                      : Container()
                ],
              ),
            ),
            const Divider(
              height: 1,
            )
          ],
        ),
      )),
    );
  }
}
