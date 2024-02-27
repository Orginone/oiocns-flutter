import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/main_base.dart';

//用户信息
class UserInfo extends StatelessWidget {
  late Rx<XEntity> userEntity;

  UserInfo({required String userId, super.key}) {
    null != relationCtrl.user
        ? relationCtrl.user!
            .findEntityAsync(userId)
            .then((value) => userEntity.value = value!)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: userEntity == null,
      child: Text(userEntity.value.name!),
    );
  }
}
