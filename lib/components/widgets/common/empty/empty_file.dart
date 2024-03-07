import 'package:flutter/widgets.dart';
import 'package:orginone/utils/load_image.dart';

import 'empty_widget.dart';

class EmptyFile extends StatelessWidget {
  const EmptyFile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyWidget(title: "暂无文件", iconPath: XImage.emptyFile);
  }
}
