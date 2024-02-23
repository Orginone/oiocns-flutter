// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/widgets/button.dart';
import 'package:orginone/config/index.dart';

import '../common/routers/names.dart';

class AlertDialogUtils {
  static showPrivateKey(BuildContext context, String privateKey) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.white,
              shadowColor: Colors.grey.shade50,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.centerLeft,
                      child: Column(children: [
                        Container(
                          padding: const EdgeInsets.only(left: 0),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            '账户私钥',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  height: 45,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: Colors.amber.shade50,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: Color(0xFFE7E8EB)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    '请妥善保管私钥，请勿告诉他人',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 16),
                                  )),
                              Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  height: 45,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: Colors.amber.shade50,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: Color(0xFFE7E8EB)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    '该私钥可以为你重置密码，加解密数据',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 16),
                                  )),
                              Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  height: 45,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: Colors.amber.shade50,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: Color(0xFFE7E8EB)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    '可拍照截图保存',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 16),
                                  )),
                              Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  height: 45,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: Colors.amber.shade50,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: Color(0xFFE7E8EB)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    privateKey,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 19),
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 45,
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: XColors.themeColor,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1, color: Color(0xFFE7E8EB)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: ButtonWidget.textFilled(
                                    bgColor: XColors.themeColor,
                                    height: 45,
                                    '我知道了，去登录',
                                    textColor: XColors.white, onTap: () {
                                  Get.toNamed(Routers.login);
                                }, textSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    );
                  },
                ),
              ));
        });
  }
}
