import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/util/hub_util.dart';

import '../../../../../api_resp/api_resp.dart';
import '../../../../../config/custom_colors.dart';

class ChatFunc extends StatelessWidget {
  final MessageDetailResp messageDetail;

  const ChatFunc(this.messageDetail, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: CustomColors.lightBlack.withAlpha(200),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          direction: Axis.horizontal,
          children: [
            IconFunc(Icons.keyboard_return, "撤回", () async {
              var res = await HubUtil().recallMsg(messageDetail.id);
              var apiResp = ApiResp.fromMap(res);
              if (apiResp.code != 200) {
                Fluttertoast.showToast(msg: apiResp.msg);
              }
            })
          ],
        ));
  }
}

class IconFunc extends StatelessWidget {
  final IconData iconData;
  final String label;
  final Function pressedCallback;

  const IconFunc(this.iconData, this.label, this.pressedCallback, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        pressedCallback();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: Colors.white,
            size: 20,
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          )
        ],
      ),
    );
  }
}
