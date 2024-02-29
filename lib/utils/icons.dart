import 'package:orginone/common/values/images.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/utils/load_image.dart';

class IconsUtils {
  static Map<String, Map<String, String>> icons = {
    "x": {
      ///系统logo
      XImage.logo: "assets/icons/logo.png",
      //================================================================== navbar
      ///沟通
      XImage.chat: "assets/icons/navbar/chat.svg",

      ///办事
      XImage.work: "assets/icons/navbar/work.svg",

      ///门户
      XImage.home: "assets/icons/navbar/home.svg",

      ///数据（存储）
      XImage.store: "assets/icons/navbar/store.svg",

      ///关系
      XImage.relation: "assets/icons/navbar/relation.svg",

      //================================================================== topbar
      // ///成员线条
      // XImage.relationOutline: "assets/icons/topbar/relation.svg",
      //成员线条
      XImage.memberOutline: "assets/icons/topbar/relation.svg",

      ///沟通线条
      XImage.chatOutline: "assets/icons/topbar/chat.svg",

      ///动态线条
      XImage.dynamicOutline: "assets/icons/topbar/activity.svg",

      ///文件线条
      XImage.fileOutline: "assets/icons/topbar/store.svg",

      ///设置线条
      XImage.settingOutline: "assets/icons/topbar/set.svg",

      //================================================================== toolbar
      ///页面-操作按钮
      ///
      ///扫码
      XImage.scan: "assets/icons/toolbar/scan.svg",

      ///新增
      XImage.add: "assets/icons/toolbar/add.svg",

      ///发起办事
      XImage.startWork: "assets/icons/toolbar/newWork.svg",

      ///添加存储
      XImage.addStorage: "assets/icons/toolbar/newStorage.svg",

      ///搜索
      XImage.search: "assets/icons/toolbar/search.svg",

      //================================================================== operate
      ///动态-操作按钮
      ///点赞线条
      XImage.likeOutline: "assets/icons/operate/Like_Outline.svg",

      ///点赞填充
      XImage.likeFill: "assets/icons/operate/Like_Fill.svg",

      ///评论线条
      XImage.commentOutline: "assets/icons/operate/Communication.svg",

      ///删除线条
      XImage.deleteOutline: "assets/icons/operate/Delete.svg",

      ///沟通-操作按钮
      ///转发
      XImage.forward: "assets/icons/operate/Forward.svg",

      ///复制
      XImage.copyOutline: "assets/icons/operate/copyOutline.svg",

      ///引用
      XImage.quote: "assets/icons/operate/devices-share.svg",

      ///撤回
      XImage.recall: "assets/icons/operate/message-x.svg",

      ///事项提醒-工作台
      ///
      ///办事
      XImage.homeWork: "assets/icons/operate/home_work.svg",

      ///任务
      XImage.homeTask: "assets/icons/operate/home_task.svg",

      ///提醒
      XImage.homeRemind: "assets/icons/operate/home_remind.svg",

      ///未读消息
      XImage.homeChat: "assets/icons/operate/home_chat.svg",

      ///快捷操作-工作台
      ///添加好友
      XImage.addFriend: "assets/icons/operate/add_friend.svg",

      ///创建群组
      XImage.createGroup: "assets/icons/operate/create_group.svg",

      ///加入群组
      XImage.joinGroup: "assets/icons/operate/join_group.svg",

      ///申请存储
      XImage.applyStorage: "assets/icons/operate/apply_storage.svg",

      ///设立单位
      XImage.establishmentUnit: "assets/icons/operate/establishment_unit.svg",

      ///加入单位
      XImage.joinUnit: "assets/icons/operate/join_unit.svg",

      // //动态
      // XImage.dynamicIcon: "assets/icons/dynamic.svg",
      // //设置
      // XImage.settings: "assets/icons/settings.svg",

      //================================================================== types/folders
      ///数据标准
      ///属性
      XImage.folderProperties: "assets/icons/types/folders/properties.svg",

      ///分类
      XImage.folderClassification:
          "assets/icons/types/folders/classification.svg",

      ///字典
      XImage.folderDictionary: "assets/icons/types/folders/dictionary.svg",

      ///表单
      XImage.folderForm: "assets/icons/types/folders/form.svg",

      ///报表
      ///迁移
      ///页面模版
      ///业务模型
      XImage.folderModel: "assets/icons/types/folders/model.svg",

      ///应用
      XImage.folderApplication: "assets/icons/types/folders/application.svg",

      ///文件
      XImage.folderStore: "assets/icons/types/folders/store.svg",

      ///代码
      XImage.folderCode: "assets/icons/types/folders/code.svg",

      ///镜像
      XImage.folderImage: "assets/icons/types/folders/image.svg",
      // ///资源
      // XImage.folderStore: "assets/icons/types/folders/store.svg",

      ///目录
      XImage.folder: "assets/icons/types/folders/folder.svg",

      //================================================================== types/files
      ///pdf
      XImage.pdf: "assets/icons/types/files/pdf.svg",

      ///word
      XImage.word: "assets/icons/types/files/word.svg",

      ///excel
      XImage.excel: "assets/icons/types/files/excel.svg",

      ///ppt
      XImage.ppt: "assets/icons/types/files/ppt.svg",

      ///音频
      XImage.music: "assets/icons/types/files/audio.svg",

      ///视频
      XImage.video: "assets/icons/types/files/video.svg",

      ///图片
      XImage.image: "assets/icons/types/files/picture.svg",

      ///app应用
      XImage.app: "assets/icons/types/files/application.svg",

      ///文件
      XImage.file: "assets/icons/types/files/file.svg",
      //================================================================== types
      ///属性
      XImage.property: "assets/icons/types/property.svg",

      ///用户
      XImage.user: "assets/icons/types/user.svg",

      ///群组
      XImage.communicationGroup: "assets/icons/types/cohort.svg",

      ///内设机构
      XImage.unitInstitution: "assets/icons/types/department.svg",

      ///组织群-集群
      XImage.cluster: "assets/icons/types/group.svg",

      ///单位
      XImage.unit: "assets/icons/types/company.svg",

      ///应用
      XImage.application: "assets/icons/types/application.svg",

      ///表单
      XImage.form: "assets/icons/types/form.svg",

      ///页面模版
      XImage.pageTemplate: "assets/icons/types/page.svg",

      ///表单办事
      XImage.formWork: "assets/icons/types/apply.svg",

      ///办事-申请加入人员
      XImage.workApplyAddPerson: "assets/icons/types/joinFriend.svg",

      ///办事-申请加入单位
      XImage.workApplyAddUnit: "assets/icons/types/joinCompany.svg",

      ///办事-申请加入群组
      XImage.workApplyAddGroup: "assets/icons/types/joinCohort.svg",

      ///办事-申请加入存储资源
      XImage.workApplyAddStorage: "assets/icons/types/joinStorage.svg",

      ///办事-申请加入群
      XImage.workApplyAddCohort: "assets/icons/types/joinGroup.svg",

      ///办事-子流程
      XImage.workSend: "assets/icons/types/workSend.svg",

      ///动态
      XImage.activity: "assets/icons/types/activity.svg",

      ///字典
      XImage.dictionary: "assets/icons/types/dictionary.svg",

      ///分类
      XImage.species: "assets/icons/types/species.svg",

      //==================================================================
      // "defalutAvatar": "assets/icons/defalut_avatar.png",
      // 'joinFriend': "assets/icons/joinFriend.svg",
      // 'joinStorage': "assets/icons/shop.png",
      // 'newCohort': "assets/icons/newCohort.svg",
      // 'joinCohort': "assets/icons/joinCohort.svg",
      // 'newCompany': "assets/icons/newCompany.svg",
      // 'joinCompany': "assets/icons/joinCompany.svg",

      // "chat": "assets/icons/chat-select.svg",
      // "unchat": "assets/icons/chat.svg",
      // "work": "assets/icons/work-select.svg",
      // "unwork": "assets/icons/work.svg",
      // "home": "assets/icons/home-select.svg",
      // "unhome": "assets/icons/home.svg",
      // "store": "assets/icons/store-select.svg",
      // "unstore": "assets/icons/store.svg",
      // "relation": "assets/icons/relation-select.svg",
      // "unrelation": "assets/icons/relation.svg",
      // "setting": "assets/icons/setting-select.svg",
      // "unsetting": "assets/icons/setting.svg",
      // "logo": "assets/icons/logo.png",
      // "defalutAvatar": "assets/icons/defalut_avatar.png",
      // "shop": "assets/icons/shop.png",
      // "unshop": "assets/icons/unshop.png",
      // 'joinFriend': "assets/icons/joinFriend.svg",
      // 'joinStorage': "assets/icons/shop.png",
      // 'newCohort': "assets/icons/newCohort.svg",
      // 'joinCohort': "assets/icons/joinCohort.svg",
      // 'newCompany': "assets/icons/newCompany.svg",
      // 'joinCompany': "assets/icons/joinCompany.svg",
    },
    "2x": {},
    "3x": {},
  };

  @Deprecated("旧方法弃用，统一使用XImage.entityIcon")
  static String workDefaultAvatar(String typeName) {
    String defaultAvatar = '';
    if (typeName == WorkType.addPerson.label) {
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
    } else if (typeName == "目录") {
      defaultAvatar = AssetsImages.dirIcon;
    } else if (typeName == "好友") {
      defaultAvatar = AssetsImages.chatDefaultPerson;
    } else if (typeName == "群组") {
      defaultAvatar = AssetsImages.chatDefaultCohort;
    } else if (typeName == "组织群") {
      defaultAvatar = AssetsImages.chatDefaultCohort;
    } else if (typeName == "成员") {
      defaultAvatar = AssetsImages.chatDefaultPerson;
    } else if (typeName == "内设机构") {
      defaultAvatar = AssetsImages.dirIcon;
    } else if (typeName == "资源") {
      defaultAvatar = AssetsImages.dirIcon;
    } else {
      defaultAvatar = AssetsImages.dirIcon;
    }
    return defaultAvatar;
  }
}
