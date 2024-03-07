import 'package:flutter/material.dart';
import 'package:orginone/utils/load_image.dart';

/// 空白页
class EmptyWidget extends StatelessWidget {
  String? title;
  String? iconPath;

  EmptyWidget({Key? key, this.title, this.iconPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            XImage.localImage(iconPath ?? XImage.emptyPage, width: 150),
            Text(title ?? "暂无数据"),
            const SizedBox(
              width: double.infinity,
              height: 200,
            )
          ],
        ),
      ),
    );
  }
}
