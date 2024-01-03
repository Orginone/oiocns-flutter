import 'package:orginone/env.dart';

class Constant {
  static const projectName = "Orginone";
  static String host = EnvConfig.baseHost;

  static String messageHub = "$host/orginone/orgchat/msghub";
  static String anyStoreHub = "$host/orginone/anydata/hub";
  static String kernelHub = "$host/orginone/kernel/hub";
  static String kernel = "$host/orginone/kernel/rest";
  static String person = "$host/orginone/organization/person";
  static String company = "$host/orginone/organization/company";
  static String cohort = "$host/orginone/organization/cohort";
  static String collection = "$host/orginone/anydata/collection";
  static String bucket = "$host/orginone/anydata/Bucket";
  static String workflow = "$host/orginone/organization/workflow";
  static String market = "$host/orginone/appstore/market";
  static String order = "$host/orginone/appstore/order";
  static String product = "$host/orginone/appstore/product";
  static String rest = "$host/orginone/kernel/rest";
  static String userName = EnvConfig.userName;
  static String pwd = EnvConfig.pwd;
}
