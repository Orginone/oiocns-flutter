import 'package:flutter/material.dart';

//组件布局组件字段 顺序是从左到右
class FormItemType2 extends StatelessWidget {
  //左侧文字
  final String? text;
  //右侧插槽
  final Widget? rightSlot;
  //最右侧的图标
  final Icon? suffixIcon;
  //全局的点击事件
  final Function? callback1;
  //最右侧图标的点击事件
  final Function? callback2;

  const FormItemType2({
    Key? key,
    this.text,
    this.rightSlot,
    this.suffixIcon,
    this.callback1,
    this.callback2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
          child: InkWell(
        onTap: () {
          callback1 != null ? callback1!() : () => {};
        },
        child: Column( children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child:
                      Text(text ?? '', style: const TextStyle(fontSize: 16)),
                    ),
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children:
                                rightSlot != null ? [rightSlot!] : []))),
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
                        : Container(
                      height: 30,
                    )
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
          )
        ],),
      )),
    );
  }
}
