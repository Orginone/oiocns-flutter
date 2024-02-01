import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/modules/cardbag/index.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:orginone/components/widgets/system/buttons.dart';
import 'package:orginone/config/unified.dart';

class VerifyMnemonic extends StatefulWidget {
  const VerifyMnemonic({Key? key}) : super(key: key);

  @override
  State<VerifyMnemonic> createState() => _VerifyMnemonicState();
}

class _VerifyMnemonicState extends State<VerifyMnemonic> {
  CreateBagController get controller => Get.find();

  List<_VerifyWord> sortMnemonics = [];

  List<_VerifyWord> verifyMnemonics = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sortMnemonics = List.generate(controller.state.mnemonics.length,
        (index) => _VerifyWord(index, controller.state.mnemonics[index]));
    sortMnemonics.sort((a, b) => Random().nextInt(100) > 30 ? 1 : -1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 30.h),
          Text("验证助记词", style: XFonts.size26Black0W700),
          SizedBox(height: 15.h),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(width: 0.5, color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(15.w)),
            height: 300.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10.w,
                  mainAxisExtent: 60.h,
                  crossAxisSpacing: 10.h),
              itemBuilder: (context, index) {
                return _PickedWordToVerify(
                  verify: verifyMnemonics[index],
                  onClickPickedWord: (word) {
                    verifyMnemonics.remove(word);
                    setState(() {});
                  },
                );
              },
              itemCount: verifyMnemonics.length,
            ),
          ),
          SizedBox(height: 15.h),
          const Text("请按正确的顺序点击助记词"),
          SizedBox(height: 15.h),
          Expanded(
            child: GridMnemonicsView(
              keys: sortMnemonics.map((e) => e.word).toList(),
              isSelected: (index) {
                return verifyMnemonics.contains(sortMnemonics[index]);
              },
              callback: (index) {
                if (verifyMnemonics.contains(sortMnemonics[index])) {
                  verifyMnemonics.remove(sortMnemonics[index]);
                } else {
                  verifyMnemonics.add(sortMnemonics[index]);
                }
                setState(() {});
              },
            ),
          ),
          SizedBox(height: 20.h),
          elevatedButton("确认", onPressed: () {
            String rightMnemonics = controller.state.mnemonics.join(' ');
            String verifyMnemonicsString =
                verifyMnemonics.map((e) => e.word).toList().join(' ');
            if (rightMnemonics == verifyMnemonicsString) {
              ToastUtils.showMsg(msg: "助记词验证成功");
              controller.nextPage();
            } else {
              ToastUtils.showMsg(msg: "助记词验证失败");
            }
          }),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

class _PickedWordToVerify extends StatelessWidget {
  final _VerifyWord verify;
  final void Function(_VerifyWord word)? onClickPickedWord;

  const _PickedWordToVerify({
    Key? key,
    required this.verify,
    this.onClickPickedWord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        onClickPickedWord?.call(verify);
      },
      style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xfffafafa),
          side: const BorderSide(color: Colors.black12)),
      child: Text(
        verify.word,
        style: XFonts.size18Black0,
      ),
    );
  }
}

class _VerifyWord {
  final int index;
  String word;

  _VerifyWord(this.index, this.word);
}
