import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/models/index.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/main_bean.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';

import 'item.dart';

class BagDetailsPage extends StatefulWidget {
  const BagDetailsPage({Key? key}) : super(key: key);

  @override
  State<BagDetailsPage> createState() => _BagDetailsPageState();
}

class _BagDetailsPageState extends State<BagDetailsPage> {
  late Rx<Wallet> wallet;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    wallet = Rx(Get.arguments['wallet']);

    walletCtrl.queryWalletBalance(wallet.value);
  }

  @override
  Widget build(BuildContext context) {
    return GyScaffold(
      titleName: wallet.value.account,
      actions: [
        IconButton(
          onPressed: () {
            Get.toNamed(Routers.searchCoin, arguments: {"wallet": wallet});
          },
          icon: const Icon(Icons.add),
          color: Colors.black,
        )
      ],
      body: Obx(() {
        return ListView.builder(
          itemBuilder: (context, index) {
            Coin coin = wallet.value.coins![index];

            return Item(coin: coin);
          },
          itemCount: wallet.value.coins?.length ?? 0,
        );
      }),
    );
  }
}
