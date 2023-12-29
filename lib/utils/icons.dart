import 'package:orginone/common/values/images.dart';
import 'package:orginone/dart/core/public/enums.dart';

class IconsUtils {
  static Map<String, Map<String, String>> icons = {
    "x": {
      "chat": "assets/icons/chat-select.svg",
      "unchat": "assets/icons/chat.svg",
      "work": "assets/icons/work-select.svg",
      "unwork": "assets/icons/work.svg",
      "home": "assets/icons/home-select.svg",
      "unhome": "assets/icons/home.svg",
      "store": "assets/icons/store-select.svg",
      "unstore": "assets/icons/store.svg",
      "relation": "assets/icons/relation-select.svg",
      "unrelation": "assets/icons/relation.svg",
      "setting": "assets/icons/setting-select.svg",
      "unsetting": "assets/icons/setting.svg",
      "logo": "assets/icons/logo.png",
      "defalutAvatar": "assets/icons/defalut_avatar.png",
      "shop": "assets/icons/shop.png",
      "unshop": "assets/icons/unshop.png",
      'joinFriend': "assets/icons/joinFriend.svg",
      'joinStorage': "assets/icons/shop.png",
      'newCohort': "assets/icons/newCohort.svg",
      'joinCohort': "assets/icons/joinCohort.svg",
      'newCompany': "assets/icons/newCompany.svg",
      'joinCompany': "assets/icons/joinCompany.svg",
    },
    "2x": {},
    "3x": {},
  };

  static String workDefaultAvatar(String typeName) {
    String defaultAvatar = '';
    if (typeName == WorkType.add.label) {
      defaultAvatar = AssetsImages.workAdd;
    } else if (typeName == WorkType.thing.label) {
      defaultAvatar = AssetsImages.workThing;
    } else if (typeName == TargetType.company.label) {
      defaultAvatar = AssetsImages.workCompang;
    } else if (typeName == TargetType.storage.label) {
      defaultAvatar = AssetsImages.workStore;
    } else {
      defaultAvatar = icons['x']?['work'] ?? "";
    }
    if (typeName == TargetType.person.label) {
      defaultAvatar = AssetsImages.chatDefaultPerson;
    } else if (typeName == TargetType.cohort.label) {
      defaultAvatar = AssetsImages.chatDefaultCohort;
    } else if (typeName == TargetType.department.label) {
      defaultAvatar = AssetsImages.chatDefaultCohort;
    } else if (typeName == '动态') {
    } else if (typeName == TargetType.group.label) {
      defaultAvatar = AssetsImages.chatDefaultCohort;
    } else if (typeName == '动态') {
      defaultAvatar = IconsUtils.icons['x']?['home'] ?? "";
    }
    return defaultAvatar;
  }
}
