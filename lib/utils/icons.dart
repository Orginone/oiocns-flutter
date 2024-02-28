import 'package:orginone/common/values/images.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/utils/load_image.dart';

class IconsUtils {
  static Map<String, Map<String, String>> icons = {
    "x": {
      //沟通
      XImage.chat: "assets/icons/chat.svg",
      //沟通线条
      XImage.chatOutline: "assets/icons/chatOutline.svg",
      //办事
      XImage.work: "assets/icons/work.svg",
      //门户
      XImage.home: "assets/icons/home.svg",
      //数据（存储）
      XImage.store: "assets/icons/store.svg",
      //关系
      XImage.relation: "assets/icons/relation.svg",
      //关系线条
      XImage.relationOutline: "assets/icons/relation.svg",

      ///工作台图标
      ///
      ///办事
      XImage.homeWork: "assets/icons/home_work.svg",

      ///任务
      XImage.homeTask: "assets/icons/home_task.svg",

      ///提醒
      XImage.homeRemind: "assets/icons/home_remind.svg",

      ///未读消息
      XImage.homeChat: "assets/icons/home_chat.svg",
      //系统logo
      XImage.logo: "assets/icons/logo.png",
      //动态
      XImage.dynamicIcon: "assets/icons/dynamic.svg",
      //动态线条
      XImage.dynamicOutline:
          "assets/icons/Top bar - Right side _ Dynamic_Outline.svg",
      //文件
      XImage.file: "assets/icons/file.svg",
      //文件线条
      XImage.fileOutline:
          "assets/icons/Top bar - Right side _ File_Outline.svg",
      //设置
      XImage.settings: "assets/icons/settings.svg",
      XImage.settingOutline:
          "assets/icons/Top bar - right side _ settings_Outline.svg",

      //成员
      XImage.memberOutline:
          "assets/icons/Top bar - right side _ application_Outline-1.svg",

      //添加好友
      XImage.addFriend: "assets/icons/add_friend.svg",
      //创建群组
      XImage.createGroup: "assets/icons/create_group.svg",
      //加入群组
      XImage.joinGroup: "assets/icons/join_group.svg",
      //申请存储
      XImage.applyStorage: "assets/icons/apply_storage.svg",
      //设立单位
      XImage.establishmentUnit: "assets/icons/establishment_unit.svg",
      //加入单位
      XImage.joinUnit: "assets/icons/join_unit.svg",

      //目录
      XImage.folder: "assets/icons/folder.svg",

      ///属性
      XImage.property: "assets/icons/property.svg",
      //资源
      XImage.folderStore: "assets/icons/folder_store.svg",
      //用户
      XImage.user: "assets/icons/user.svg",
      //群组
      XImage.communicationGroup: "assets/icons/communication_group.svg",
      //内设机构
      XImage.unitInstitution: "assets/icons/Communication_Department-1.svg",
      //集群
      XImage.cluster: "assets/icons/Communication_cluster.svg",
      //单位
      XImage.unit: "assets/icons/Communication_Unit-1.svg",
      //pdf
      XImage.pdf: "assets/icons/pdf.svg",
      //word
      XImage.word: "assets/icons/word.svg",
      //excel
      XImage.excel: "assets/icons/excel.svg",
      //ppt
      XImage.ppt: "assets/icons/file_ppt.svg",
      //音频
      XImage.music: "assets/icons/audio.svg",
      //视频
      XImage.video: "assets/icons/file_video.svg",
      //图片
      XImage.image: "assets/icons/image.svg",

      ///app应用
      XImage.app: "assets/icons/File_Application.svg",

      ///表单
      XImage.form: "assets/icons/form.svg",

      ///页面模版
      XImage.pageTemplate: "assets/icons/page.svg",

      ///搜索
      XImage.search: "assets/icons/search.svg",

      ///扫码
      XImage.scan: "assets/icons/scan.svg",

      ///新增
      XImage.add: "assets/icons/add.svg",

      ///发起办事
      XImage.startWork: "assets/icons/tab-search bar right_side_service.svg",

      ///添加存储
      XImage.addStorage: "assets/icons/tab-search bar right side_data.svg",

      ///点赞线条
      XImage.likeOutline: "assets/icons/Like_Outline.svg",

      ///点赞填充
      XImage.likeFill: "assets/icons/Like_Fill.svg",

      ///转发
      XImage.forward: "assets/icons/Forward.svg",

      ///复制
      XImage.copyOutline: "assets/icons/copyOutline.svg",

      ///引用
      XImage.quote: "assets/icons/devices-share.svg",

      ///撤回
      XImage.recall: "assets/icons/message-x.svg",

      ///评论线条
      XImage.commentOutline: "assets/icons/Communication.svg",

      ///删除线条
      XImage.deleteOutline: "assets/icons/Delete.svg",

      ///表单办事
      XImage.formWork: "assets/icons/work_1.svg",

      ///办事-申请加入人员
      XImage.workApplyAddPerson: "assets/icons/work_apply_add_person.svg",

      ///办事-申请加入单位
      XImage.workApplyAddUnit: "assets/icons/work_apply_add_unit.svg",

      ///办事-申请加入群组
      XImage.workApplyAddGroup: "assets/icons/work_apply_add_group.svg",

      ///办事-申请加入存储资源
      XImage.workApplyAddStorage: "assets/icons/work_apply_add_storage.svg",

      ///办事-申请加入群
      XImage.workApplyAddCohort: "assets/icons/work_apply_add_cohort.svg",

      ///应用
      XImage.application: "assets/icons/application.svg",

      ///动态
      XImage.activity: "assets/icons/activity.svg",

      ///字典
      XImage.dictionary: "assets/icons/dictionary.svg",

      ///分类
      XImage.species: "assets/icons/species.svg",

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
