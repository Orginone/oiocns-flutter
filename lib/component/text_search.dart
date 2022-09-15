import 'package:flutter/material.dart';
import 'package:orginone/component/unified_text_style.dart';

import '../config/custom_colors.dart';

const EdgeInsets defaultMargin = EdgeInsets.all(10);

class TextSearch extends StatelessWidget {
  final EdgeInsets? margin;
  final Function searchingCallback;

  const TextSearch(this.searchingCallback,
      {Key? key, this.margin = defaultMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: CustomColors.searchGrey),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: const Icon(
              Icons.search,
              color: Colors.black,
            )),
        Expanded(
          child: TextFormField(
            controller: TextEditingController(),
            onChanged: (newVal) {
              searchingCallback(newVal);
            },
            style: text16,
            decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: '请输入搜索内容'),
          ),
        )
      ]),
    );
  }
}
