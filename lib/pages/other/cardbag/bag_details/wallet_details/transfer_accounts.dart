import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/main.dart';
import 'package:orginone/model/wallet_model.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/loading_dialog.dart';
import 'package:orginone/widget/unified.dart';

class TransferAccounts extends StatefulWidget {
  const TransferAccounts({Key? key}) : super(key: key);

  @override
  State<TransferAccounts> createState() => _TransferAccountsState();
}

class _TransferAccountsState extends State<TransferAccounts> {
  late TextEditingController amountController;

  late TextEditingController toController;

  late TextEditingController noteController;

  late Coin coin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coin = Get.arguments['coin'];
    amountController = TextEditingController();
    toController = TextEditingController();
    noteController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GyScaffold(
      titleName: "转账",
      backgroundColor: Colors.white,
      elevation: 0.5,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidget.commonHeadInfoWidget("付款金额"),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: XColors.statisticsBoxColor,
              border: Border.all(color: XColors.blueTextColor, width: 0.5),
              borderRadius: BorderRadius.circular(32.w),
            ),
            child: TextField(
              controller: amountController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
              ],
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "输入金额",
                  hintStyle: TextStyle(color: Colors.white, fontSize: 18.sp)),
              maxLines: 1,
            ),
          ),
          CommonWidget.commonHeadInfoWidget(
            "收款方",
            action: IconButton(
              icon: const Icon(Ionicons.scan_outline),
              onPressed: () {
                Get.toNamed(Routers.qrScan)?.then((value) async {
                  if(value!=null){
                    toController.text = value;
                  }
                });
              },
              color: Colors.black,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(minHeight: 36.h),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: TextField(
              controller: toController,
              decoration: const InputDecoration(
                hintText: "搜索或输入地址",
              ),
              maxLines: 1,
            ),
          ),
          CommonWidget.commonHeadInfoWidget("转账备注"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: TextField(
              controller: noteController,
              decoration: const InputDecoration(
                hintText: "输入备注",
              ),
              maxLines: 1,
            ),
          ),
          GestureDetector(
            onTap: () async{
              LoadingDialog.showLoading(context);
              bool success = await walletCtrl.createTransaction(coin, amountController.text, toController.text, noteController.text);
              LoadingDialog.dismiss(context);
              if(success){
                ToastUtils.showMsg(msg: "转账成功");
              }else{
                ToastUtils.showMsg(msg: "转账失败");
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
              decoration: BoxDecoration(
                color: XColors.blueTextColor,
                borderRadius: BorderRadius.circular(32.w),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              width: double.infinity,
              child: Text(
                "确认转账",
                style: TextStyle(color: Colors.white, fontSize: 26.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
