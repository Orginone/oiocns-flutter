import 'package:flutter/material.dart';

//渲染列表项
class ListItemMetaWidget extends StatelessWidget {
  Widget title;
  Widget avatar;
  Widget description;
  Function()? onTap;
  ListItemMetaWidget(
      {super.key,
      required this.title,
      required this.avatar,
      required this.description,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: description,
      leading: avatar,
      onTap: onTap,
    );

    // Container(
    //     child: Row(
    //   children: [
    //     avatar,
    //     Column(
    //       children: [title, description],
    //     )
    //   ],
    // ));
  }
}
