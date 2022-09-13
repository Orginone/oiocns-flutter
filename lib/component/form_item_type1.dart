import 'package:flutter/material.dart';

import '../config/custom_colors.dart';

const Color defaultBgColor = CustomColors.lightGrey;

class FormItemType1 extends StatelessWidget {
  final Color bgColor;
  final String? title;
  final String? text;
  final Icon? suffixIcon;
  final Function? callback;

  const FormItemType1(
      {Key? key,
        this.bgColor = defaultBgColor,
        this.callback,
        this.title,
        this.text,
        this.suffixIcon,
      })
      : super(key: key);

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:
                    const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Text(title ?? '',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(
                                130, 130, 130, 1))),
                  ),
                  Text(
                      text ?? '',
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
              suffixIcon != null ?
              IconButton(
                  onPressed: () {
                    callback != null ? callback!() : ()=>{};
                  },
                  icon: suffixIcon!
              ) : Container()
            ],
          )
        ],
      ),
    );
  }
}
