import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import '../../../../dart/core/getx/base_controller.dart';
import 'item.dart';
import '../../../../dart/core/getx/base_get_view.dart';

class BagDetailsPage extends StatefulWidget {
  const BagDetailsPage({Key? key}) : super(key: key);

  @override
  State<BagDetailsPage> createState() => _BagDetailsPageState();
}

class _BagDetailsPageState extends State<BagDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return GyScaffold(
      titleName: "111",
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.add),
          color: Colors.black,
        )
      ],
      body: ListView.builder(itemBuilder: (context,index){
        return Item(
          name: "BTC",
          cnName: "比特币",
          onTap: (){
            Get.toNamed(Routers.walletDetails);
          },
        );
      },itemCount: 2,),
    );
  }
}

