import 'package:get/get.dart';
import 'package:orginone/utils/load_image.dart';
import 'package:orginone/utils/regex/regex_constants.dart';

/// 用户对象类型
enum WorkType {
  //外部用户
  addPerson("加人员", XImage.workApplyAddPerson),
  addUnit("加单位", XImage.workApplyAddUnit),
  addGroup("加群组", XImage.workApplyAddGroup),
  addStorage("加存储资源", XImage.workApplyAddStorage),
  addCohort("加组织群", XImage.workApplyAddCohort),

  thing("事项", XImage.formWork);

  const WorkType(this.label, this.icon);

  final String label;
  final String icon;

  static String getName(TargetType type) {
    return type.label;
  }

  static WorkType getType(String name) {
    return WorkType.values.firstWhere((element) => element.label == name);
  }
}

/// 用户对象类型
enum TargetType {
  //外部用户
  group("组织群", XImage.cluster),
  cohort("群组", XImage.communicationGroup),
  //内部用户
  college("学院", XImage.folder),
  department("部门", XImage.unitInstitution),
  office("办事处", XImage.unitInstitution),
  section("科室", XImage.unitInstitution),
  major("专业", XImage.unitInstitution),
  working("工作组", XImage.unitInstitution),
  research("研究所", XImage.unitInstitution),
  laboratory("实验室", XImage.unitInstitution),

  ///岗位
  station("岗位", XImage.folder),
  //自归属用户
  person("人员", XImage.user),
  company("单位", XImage.unit),
  university("大学", XImage.folder),
  hospital("医院", XImage.folder),
  storage("存储资源", XImage.folderStore),
  jobCohort("工作群", XImage.folder), //内核不存在了
  activity("动态", XImage.activity),
  ;

  const TargetType(this.label, this.icon);

  final String label;

  final String icon;

  static String getName(TargetType type) {
    return type.label;
  }

  static TargetType? getType(String name) {
    return TargetType.values
        .firstWhereOrNull((element) => element.label == name);
  }
}

/// 目录分类
// @Deprecated("DirectoryType")
enum DirectoryGroupType {
  // 人员
  person("人员", [SpaceEnum.groups, SpaceEnum.resources]),

  // 单位
  company("单位", [
    SpaceEnum.groups,
    SpaceEnum.internalAgent,
    SpaceEnum.cohorts,
    SpaceEnum.resources
  ]),

  // 存储
  storage("存储资源", [
    SpaceEnum.dataStandards,
    SpaceEnum.businessModeling,
    SpaceEnum.applications,
    SpaceEnum.file,
    SpaceEnum.code,
    SpaceEnum.mirroring,
  ]),

  /// 数据标准
  dataStandards("数据标准", [
    SpaceEnum.property,
    SpaceEnum.species,
    SpaceEnum.dict,
  ]),
  ;

  const DirectoryGroupType(this.name, this.types);

  final List<SpaceEnum> types;
  final String name;

  static List<SpaceEnum> getName(DirectoryGroupType type) {
    return type.types;
  }

  static DirectoryGroupType? getType(String type) {
    return DirectoryGroupType.values
        .firstWhereOrNull((element) => element.name == type);
  }
}

///分类基础类型
enum SpeciesType {
  // 类别目录
  market('流通类'),
  resource('资源类'), //ts内核不存在
  store('属性类'),
  application('应用类'),
  dict('字典类'),
  // 类别类目
  flow('流程类'),
  work('事项配置'),
  thing('实体配置'),
  data('数据类');

  final String label;

  const SpeciesType(this.label);

  static SpeciesType? getType(String name) {
    try {
      return SpeciesType.values.firstWhere((element) => element.label == name);
    } catch (e) {
      return null;
    }
  }
}

/// 消息类型
enum MessageType {
  file("文件"),
  text("文本"),
  html("网页"),
  image("图片"),
  video("视频"),
  voice("语音"),
  recall("撤回"),
  notify('通知'), //ts还未实现
  uploading('upload'); //ts还未实现

  const MessageType(this.label);

  final String label;

  static String getName(MessageType type) {
    return type.label;
  }

  static MessageType? getType(String str) {
    switch (str) {
      case "文本":
        return MessageType.text;
      case "图片":
        return MessageType.image;
      case "视频":
        return MessageType.video;
      case "语音":
        return MessageType.voice;
      case "撤回":
        return MessageType.recall;
      case "通知":
        return MessageType.notify;
      case "网页":
        return MessageType.html;
      case "文件":
        return MessageType.file;
    }
    return null;
  }
}

///任务状态
enum TaskStatus {
  applyStart(0),
  approvalStart(100), //已同意
  refuseStart(200); //已拒绝

  final int status;
  const TaskStatus(this.status);
}

/// 通用状态
enum CommonStatus {
  applyStartStatus(1),
  approveStartStatus(100),
  rejectStartStatus(200);

  const CommonStatus(this.value);

  final int value;

  static int getValue(CommonStatus status) {
    return status.value;
  }
}

///变更操作
enum OperateType {
  add('新增'),
  create('创建'),
  remove('移除'),
  update('更新'),
  delete('删除');

  final String label;

  const OperateType(this.label);

  static OperateType getType(String name) {
    return OperateType.values.firstWhere((element) => element.label == name);
  }
}

///值类型 getType操作需要根据实际情况再做修改
enum ValueType {
  number('数值型'),
  remark('描述性'),
  select('选择型'),
  species('分类型'),
  file('附件型'),
  time('时间型'),
  date('日期型'),
  target('用户型');

  final String label;

  const ValueType(this.label);

  static String getName(ValueType type) {
    return type.label;
  }

  static ValueType getType(String name) {
    return ValueType.values.firstWhere((element) => element.label == name);
  }
}

///规则触发时机 ts上存在需要根据实际情况删除或保留
enum RuleTriggers {
  start("Start"), //初始化
  running("Running"), //修改后
  submit("Submit"), //提交前
  thingsChanged("ThingsChanged"); //子表变化后

  final String label;

  const RuleTriggers(this.label);

  static RuleTriggers getTrigger(String name) {
    return RuleTriggers.values.firstWhere((element) => element.label == name);
  }
}

/// 域类型
enum DomainTypes {
  user("user"),
  company("company"),
  all("all");

  const DomainTypes(this.label);

  final String label;

  static String getName(MessageType type) {
    return type.label;
  }
}

enum ProductType {
  webApp("web应用");

  const ProductType(this.label);

  final String label;

  static String getName(ProductType type) {
    return type.label;
  }
}

/// 订单状态
enum OrderStatus {
  deliver(102),
  buyerCancel(220),
  sellerCancel(221),
  rejectOrder(222);

  const OrderStatus(this.value);

  final int value;

  static int getValue(OrderStatus status) {
    return status.value;
  }
}

enum TodoType {
  frientTodo("好友申请"),
  orgTodo("组织审批"),
  orderTodo("订单管理"),
  marketTodo("市场管理"),
  applicationTodo("应用待办");

  const TodoType(this.label);

  final String label;

  static String getName(ProductType type) {
    return type.label;
  }
}

enum SpaceEnum {
  directory("目录", XImage.folder),
  species("分类", XImage.species),
  filter("筛选", XImage.folder),
  property("属性", XImage.property),
  applications("应用", XImage.application),
  module("模块", XImage.folder),
  work("办事", XImage.folder),
  form("表单", XImage.folder),
  file("文件", XImage.folder),
  user('个人', XImage.folder),
  company("公司", XImage.folder),
  person("成员", XImage.folder),
  departments("部门", XImage.unitInstitution),

  ///群组
  groups("群组", "communicationGroup"),

  ///组织
  cohorts("组织群", XImage.cluster),

  ///好友
  firend("好友", XImage.folder),

  /// 资源
  resources("资源", XImage.folderStore),

  /// 成员
  member("成员", XImage.folder),

  /// 内设机构
  internalAgent("内设机构", XImage.unitInstitution),

  /// 数据标准
  dataStandards("数据标准", XImage.folder),

  /// 业务模型
  businessModeling("业务模型", XImage.folder),

  /// 代码
  code("代码", XImage.folder),

  /// 镜像
  mirroring("镜像", XImage.folder),

  /// 字典
  dict("字典", XImage.dictionary),
  ;

  final String label;
  final String icon;

  const SpaceEnum(this.label, this.icon);

  static String getName(TargetType type) {
    return type.label;
  }

  static SpaceEnum? getType(String name) {
    return SpaceEnum.values
        .firstWhereOrNull((element) => element.label == name);
  }
}

enum StorageFileType {
  ///音频
  music("音频", XImage.music, ["video/mp3"], RegexConstants.audio),

  ///视频
  video("视频", XImage.video, ["video/mp4"], RegexConstants.vector),

  ///图片
  image(
      "图片",
      XImage.image,
      ["image/png", "image/jpeg", "image/jpg", "image/svg"],
      RegexConstants.image),

  ///pdf
  pdf("pdf", XImage.pdf, ["application/pdf"], RegexConstants.pdf),

  ///excel
  excel("excel", XImage.excel, ["xls", "xlsx"], RegexConstants.excel),

  ///word
  word("word", XImage.word, ["doc", "docx"], RegexConstants.doc),

  ///ppt
  ppt("ppt", XImage.ppt, ["ppt", "pptx"], RegexConstants.ppt),

  ///app
  app("app", XImage.app, ["apk", "ipa"], RegexConstants.app),

  ///文件
  file("文件", XImage.file, [], r'.*$'),
  ;

  final String label;
  final String icon;
  final List<String> suffixes;
  final Pattern pattern;
  const StorageFileType(this.label, this.icon, this.suffixes, this.pattern);

  static String getName(TargetType type) {
    return type.label;
  }

  static StorageFileType? getType(String name) {
    return StorageFileType.values
        .firstWhereOrNull((element) => element.suffixes.contains(name));
  }

  static StorageFileType getTypeByFileName(String name) {
    return StorageFileType.values.firstWhereOrNull((element) =>
            RegExp(element.pattern.toString(), caseSensitive: false)
                .hasMatch(name)) ??
        file;
  }
}

/// 职权类型
enum AuthorityType {
  superAdmin("super-admin"),
  relationAdmin("relation-admin"),
  thingAdmin("thing-admin"),
  marketAdmin("market-admin"),
  applicationAdmin("application-admin");

  const AuthorityType(this.label);

  final String label;

  static String getName(MessageType type) {
    return type.label;
  }
}

enum PopupMenuKey {
  createDir("新建目录"),
  createApplication("新建应用"),
  createSpecies("新建分类"),
  createDict("新建字典"),
  createAttr("新建属性"),
  createThing("新建实体配置"),
  createWork("新建事项配置"),
  createDepartment("新建部门"),
  createCompany("新建单位"),
  createStation("新建岗位"),
  createGroup("新建集群"),
  createCohort("新建群组"),
  updateInfo('更新信息'),
  rename("重命名"),
  delete("删除"),
  upload("上传文件"),
  shareQr("分享二维码"),
  setCommon("设置常用"),
  removeCommon("移除常用"),
  openChat("打开会话"),
  topping("置顶"),
  cancelTopping("取消置顶"),
  addPerson("邀请成员"),
  permission("权限设置"),
  role("角色设置"),
  station("岗位设置");

  final String label;

  const PopupMenuKey(this.label);
}

/// 文件类型
enum DirectoryType {
  /// 一级类目
  ///
  /// 存储资源
  Storage("存储资源"),

  ///数据标准
  DataStandard("数据标准"),

  ///业务模型
  Model("业务模型"),

  ///应用
  App("应用"),

  ///文件
  File("文件"),

  ///代码
  Code("代码"),

  ///镜像
  Mirror("镜像"),

  /// 二级类目
  ///
  ///属性
  Property("属性"),

  ///分类
  Species("分类"),

  ///字典
  Dict("字典"),

  ///表单
  Form("表单"),

  ///报表
  Report("报表"),

  ///模板
  PageTemplate("模板"),

  ///迁移
  Transfer("迁移");

  const DirectoryType(this.label);

  final String label;

  static String getName(DirectoryType type) {
    return type.label;
  }

  static DirectoryType getType(String name) {
    return DirectoryType.values.firstWhere((element) => element.label == name);
  }
}
