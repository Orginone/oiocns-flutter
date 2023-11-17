/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-14 18:19:43
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-13 16:04:50
 */
enum Env {
  dev, //测试环境

  prod, //正式环境
}

class EnvConfig {
  static Env? env;

  static String get baseHost {
    switch (env) {
      case Env.dev:
        return "https://orginone.cn";
      case Env.prod:
        return "https://asset.orginone.cn";
      default:
        return "https://orginone.cn";
    }
  }

  static String get appId {
    switch (env) {
      case Env.dev:
        return "640116193264406528";

      case Env.prod:
        return "";
      default:
        return "";
    }
  }

  static String get pwdEncryptKey {
    switch (env) {
      case Env.dev:
        return "763156D450C5C8E8";

      case Env.prod:
        return "763156D450C5C8E8";
      default:
        return "763156D450C5C8E8";
    }
  }
}
