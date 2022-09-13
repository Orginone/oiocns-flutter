import 'package:flutter/material.dart';

class FormItemType2 extends StatelessWidget {
  //左侧文字
  final String? text;
  //右侧插槽
  final Widget? rightSlot;
  //最右侧的图标
  final Icon? suffixIcon;
  //最右侧图标的点击事件
  final Function? callback;

  const FormItemType2({
    Key? key,
    this.text,
    this.rightSlot,
    this.suffixIcon,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Text(text ?? '',
                    style: const TextStyle(
                        fontSize: 12, color: Color.fromRGBO(130, 130, 130, 1))),
              ),
              Expanded(child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: rightSlot != null ? [
                  rightSlot!
                ] : []
              )),
              suffixIcon != null
                  ? IconButton(
                      onPressed: () {
                        callback != null ? callback!() : () => {};
                      },
                      icon: suffixIcon!)
                  : Container()
            ],
          )
        ],
      ),
    );
  }
}
