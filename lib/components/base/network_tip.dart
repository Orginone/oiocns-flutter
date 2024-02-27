import 'package:flutter/material.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/main_base.dart';

///网络提醒
class NetworkTip extends StatefulWidget {
  const NetworkTip({super.key});

  @override
  State<StatefulWidget> createState() => _NetworkTip();
}

class _NetworkTip extends State<NetworkTip> {
  bool showNetworkTip = false;

  @override
  void initState() {
    super.initState();
    relationCtrl.isConnected.listen((value) {
      setState(() {
        showNetworkTip = !value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !showNetworkTip,
      child: Container(
        alignment: Alignment.center,
        color: XColors.bgErrorColor,
        padding: EdgeInsets.all(8.w),
        height: 30,
        child: const Row(
          children: [
            Icon(Icons.error, size: 18, color: XColors.fontErrorColor),
            SizedBox(width: 18),
            Text("当前无法连接网络，可检查网络设置是否正常。",
                style: TextStyle(color: XColors.black666))
          ],
        ),
      ),
    );
  }
}
