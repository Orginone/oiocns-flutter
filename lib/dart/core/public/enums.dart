/// 用户对象类型
enum WorkType {
  //外部用户
  add("加用户"),

  thing("事项"); //内核不存在了

  const WorkType(this.label);

  final String label;

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
  group("组织群"),
  cohort("群组"),
  //内部用户
  college("学院"),
  department("部门"),
  office("办事处"),
  section("科室"),
  major("专业"),
  working("工作组"),
  research("研究所"),
  laboratory("实验室"),
  //岗位
  station("岗位"),
  //自归属用户
  person("人员"),
  company("单位"),
  university("大学"),
  hospital("医院"),
  storage("存储资源"),
  jobCohort("工作群"); //内核不存在了

  const TargetType(this.label);

  final String label;

  static String getName(TargetType type) {
    return type.label;
  }

  static TargetType getType(String name) {
    return TargetType.values.firstWhere((element) => element.label == name);
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
  directory("文件夹"),
  species("分类"),
  filter("筛选"),
  property("属性"),
  applications("应用"),
  module("模块"),
  work("办事"),
  form("表单"),
  file("文件"),
  user('个人'),
  company("公司"),
  person("成员"),
  departments("部门"),
  groups("群组"),
  cohorts("组织");

  final String label;

  const SpaceEnum(this.label);
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
