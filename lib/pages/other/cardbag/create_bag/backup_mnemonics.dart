import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/channel/wallet_channel.dart';
import 'package:orginone/main.dart';
import 'package:orginone/widget/buttons.dart';
import 'package:orginone/widget/keep_alive_widget.dart';
import 'package:orginone/widget/unified.dart';

import 'logic.dart';

class BackupMnemonics extends StatefulWidget {
  const BackupMnemonics({Key? key}) : super(key: key);

  @override
  State<BackupMnemonics> createState() => _BackupMnemonicsState();
}

class _BackupMnemonicsState extends State<BackupMnemonics>
    with TickerProviderStateMixin {
  late TabController tabController;

  List<String> chineseKey = [];

  List<String> englishKey = [];

  CreateBagController get controller => Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.wait([
        walletCtrl.loadMnemonicString(1),
        walletCtrl.loadMnemonicString(0)
      ]).then((value) {
        loadChineseKey(value[0].split(' '));
        englishKey = value[1].split(' ');
        setState(() {});
      });
    });
  }

  void loadChineseKey(List<String> keys) {
    var str = [];
    chineseKey.clear();
    for (var element in keys) {
      str.add(element);
      if (str.length == 3) {
        chineseKey.add(str.join());
        str.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Text("备份助记词", style: XFonts.size26Black0W700),
                SizedBox(height: 10.h),
                const Text("请按顺序抄录以下助记词，下一步将验证"),
                SizedBox(height: 30.h),
                TabBar(
                  tabs: const [
                    Tab(
                      text: "中文",
                    ),
                    Tab(
                      text: "English",
                    )
                  ],
                  indicatorSize: TabBarIndicatorSize.label,
                  controller: tabController,
                  isScrollable: true,
                  labelColor: Colors.lightBlueAccent,
                  indicatorColor: Colors.lightBlueAccent,
                  unselectedLabelColor: Colors.black,
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children: [
                      KeepAliveWidget(
                          child: GridMnemonicsView(
                            keys: chineseKey,
                          )),
                      KeepAliveWidget(
                          child: GridMnemonicsView(keys: englishKey)),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: outlinedButton(
                  "更换助记词",
                  onPressed: () async {
                    String value;
                    if (tabController.index == 0) {
                      value = await WalletChannel().loadMnemonicString(1);
                      loadChineseKey(value.split(' '));
                    } else {
                      value = await WalletChannel().loadMnemonicString(0);
                      englishKey = value.split(' ');
                    }
                    setState(() {});
                  },
                  height: 70.h,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36.w))),
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                child: outlinedButton("下一步", onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return ClassicGeneralDialogWidget(
                        titleText: '确认备份完成助记词',
                        contentText: '请确保助记词已经完成备份',
                        positiveText: "确定",
                        negativeText: "取消",
                        onPositiveClick: () {
                          Navigator.of(context).pop();
                          controller.setMnemonics(
                              tabController.index == 0 ? chineseKey : englishKey,
                              tabController.index == 0 ? 1 : 0);
                          controller.nextPage();
                        },
                        onNegativeClick: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Colors.blueAccent),
                      side: MaterialStateProperty.all(BorderSide.none),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36.w))),
                    ),
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.white),
                    height: 70.h),
              ),
            ],
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

class GridMnemonicsView extends StatelessWidget {
  final List<String> keys;

  final Function(int index)? callback;

  final bool Function(int index)? isSelected;


  const GridMnemonicsView({Key? key, required this.keys, this.callback,  this.isSelected}) : super(key: key);

  Size get size => Get.size;

  double get itemHeight => 64.h;

  double get itemWidth => (size.width - 30.w) / 3.0;

  double get ratio => itemWidth / itemHeight;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.h,
        childAspectRatio: ratio,
      ),
      itemBuilder: (BuildContext context, int index) {
        return OutlinedButton(
            onPressed: () {
              callback?.call(index);
            },
            child: Text(keys[index], style:(isSelected!=null && isSelected!(index))?XFonts.size18Black9:XFonts.size18Black0));
      },
      itemCount: keys.length,
    );
  }
}