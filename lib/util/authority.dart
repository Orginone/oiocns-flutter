import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';

enum OrgAuths {
  superAdmin("super-admin"),
  relationAdmin("relation-admin"),
  thingAdmin("thing-admin"),
  marketAdmin("market-admin"),
  applicationAdmin("application-admin"),
  mobileAPKAdmin("mobile-apk-admin");

  final String label;

  const OrgAuths(this.label);
}

class Auth {
  static Future<bool> isAuthorityAdmin(
      ITarget target, List<String> authorities) async {
    var settingCtrl = Get.find<SettingController>();
    if (target.id == settingCtrl.user?.id) {
      return true;
    }
    return await target.judgeHasIdentity(authorities);
  }

  /// 是否为组织管理员
  /// [targetIds] 目标对象
  static Future<bool> isSuperAdmin(ITarget target) async {
    return await isAuthorityAdmin(target, [OrgAuths.superAdmin.label]);
  }

  /// 是否为组织关系管理员
  /// [targetIds] 目标对象
  static Future<bool> isRelationAdmin(ITarget target) async {
    var authorities = [OrgAuths.superAdmin.label, OrgAuths.relationAdmin.label];
    return isAuthorityAdmin(target, authorities);
  }

  /// 是否为组织物资管理员
  /// [targetIds] 目标对象
  static Future<bool> isThingAdmin(ITarget target) async {
    var authorities = [OrgAuths.superAdmin.label, OrgAuths.thingAdmin.label];
    return isAuthorityAdmin(target, authorities);
  }

  /// 是否为组织商店管理员
  /// [targetIds] 目标对象
  static Future<bool> isMarketAdmin(ITarget target) async {
    var authorities = [OrgAuths.superAdmin.label, OrgAuths.marketAdmin.label];
    return isAuthorityAdmin(target, authorities);
  }

  /// 是否为组织应用管理员
  /// [targetIds] 目标对象
  static Future<bool> isApplicationAdmin(ITarget target) async {
    var authorities = [
      OrgAuths.superAdmin.label,
      OrgAuths.thingAdmin.label,
      OrgAuths.applicationAdmin.label,
    ];
    return isAuthorityAdmin(target, authorities);
  }
}
