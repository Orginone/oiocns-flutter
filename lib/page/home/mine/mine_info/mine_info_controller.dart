import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api_resp/target.dart';

import '../../../../logic/authority.dart';

class MineInfoController extends GetxController {
  final Logger log = Logger("MineInfoController");

  TextEditingController nickNameTextController = TextEditingController();
  TextEditingController accountTextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  Target userInfo = auth.userInfo;

  void updateUser(dynamic postData) async {
    var resMeg = await PersonApi.updateUser(postData);
    await loadAuth();
    Fluttertoast.showToast(
        msg: resMeg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
    update();
  }

  void showFormDialogWidget(
      BuildContext context, TextEditingController controller,
      {String? title,
      String? text,
      TextInputType keyboardType = TextInputType.name,
      Function? validator,
      Function? callback}) async {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    await showDialog<bool>(
      context: context,
      builder: (context) {
        //ListView防止横屏被键盘遮挡
        return ListView(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          children: [
            Form(
                key: formKey,
                child: AlertDialog(
                  title: Text(title ?? ''),
                  titlePadding: const EdgeInsets.all(10),
                  //标题文本样式
                  titleTextStyle:
                      const TextStyle(color: Colors.black87, fontSize: 20),
                  //中间显示的内容
                  content: TextFormField(
                    validator: (value) {
                      String? returnValue =
                          validator != null ? validator(value) : null;
                      return returnValue;
                    },
                    autofocus: true,
                    style: const TextStyle(height: 1.5),
                    cursorHeight: 30,
                    textInputAction: TextInputAction.next,
                    keyboardType: keyboardType,
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: text,
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 10)),
                  ),
                  //中间显示的内容边距
                  contentPadding: const EdgeInsets.all(10),
                  //底部按钮区域
                  actions: <Widget>[
                    TextButton(
                      child: const Text("确认"),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          callback != null ? callback() : () {};
                        }
                      },
                    ),
                    TextButton(
                      child: const Text("取消",
                          style: TextStyle(color: Colors.black)),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ))
          ],
        );
      },
    );
  }
}
