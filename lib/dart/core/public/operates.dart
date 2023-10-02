/// 实体的操作
enum EntityOperates {
  open(10, 'open', '打开', 'open'),
  update(11, 'update', '更新信息', 'update'),
  delete(24, 'delete', '彻底删除', 'delete'),
  remark(100, 'remark', '详细信息', 'remark'),
  qrcode(101, 'qrcode', '分享二维码', 'qrcode');

  const EntityOperates(
    this.sort,
    this.cmd,
    this.label,
    this.iconType,
  );

  final int sort;
  final String cmd;
  final String label;
  final String iconType;
  Map<String, dynamic> toJson() {
    return {
      "cmd": cmd,
      "sort": sort,
      "label": label,
      "iconType": iconType,
    };
  }

  static String getName(EntityOperates opreate) {
    return opreate.label;
  }
}

/// 文件支持的操作
enum FileOperates {
  download(20, 'download', '复制文件', 'download'),
  copy(21, 'copy', '复制文件', 'copy'),
  move(22, 'move', '剪切文件', 'move'),
  parse(7, 'parse', '粘贴文件', 'parse'),
  rename(25, 'rename', '重命名', 'rename');

  const FileOperates(
    this.sort,
    this.cmd,
    this.label,
    this.iconType,
  );

  final int sort;
  final String cmd;
  final String label;
  final String iconType;
  Map<String, dynamic> toJson() {
    return {
      "cmd": cmd,
      "sort": sort,
      "label": label,
      "iconType": iconType,
    };
  }

  static String getName(EntityOperates opreate) {
    return opreate.label;
  }
}

/// 目录支持的操作
enum DirectoryOperates {
  refresh(4, 'refresh', '刷新目录', 'refresh'),
  openFolderWithEditor(10, 'openFolderWithEditor', '打开项目', 'open'),
  newFile(5, 'newFile', '上传文件', 'newFile'),
  taskList(6, 'taskList', '上传列表', 'taskList'),
  newDir(0, 'newDir', '新建目录', 'newDir'),
  newApp(1, 'newApp', '新建应用', '应用'),
  standard(2, 'standard', '导入标准', '标准'),
  newSpecies(3, 'newSpecies', '新建分类', '分类'),
  newDict(4, 'newDict', '新建字典', '字典'),
  newProperty(5, 'newProperty', '新建属性', '属性'),
  newWork(6, 'newWork', '新建办事', '流程'),
  newModule(7, 'newModule', '新建模块', '模块'),
  newForm(8, 'newForm', '新建表单', '事项配置'),
  newTransferConfig(9, 'newTransferConfig', '新建迁移配置', '迁移配置');

  const DirectoryOperates(
    this.sort,
    this.cmd,
    this.label,
    this.iconType,
  );

  final int sort;
  final String cmd;
  final String label;
  final String iconType;
  Map<String, dynamic> toJson() {
    return {
      "cmd": cmd,
      "sort": sort,
      "label": label,
      "iconType": iconType,
    };
  }

  static String getName(EntityOperates opreate) {
    return opreate.label;
  }
}

///目录下新增
class DirectoryNew {
  final int sort = 0;
  final String cmd = 'new';
  final String label = '新建更多';
  final String iconType = "new";
  final List<DirectoryOperates> menus = [
    DirectoryOperates.newDir,
    DirectoryOperates.standard,
    DirectoryOperates.newDict,
    DirectoryOperates.newSpecies,
    DirectoryOperates.newProperty,
    DirectoryOperates.newApp,
    DirectoryOperates.newForm,
    DirectoryOperates.newTransferConfig,
  ];

  Map<String, dynamic> toJson() {
    return {
      "cmd": cmd,
      "sort": sort,
      "label": label,
      "iconType": iconType,
      'menus': menus.map((e) => e.toJson()).toList()
    };
  }
}

///新建仓库
class NewWarehouse {
  final int sort = 0;
  final String cmd = 'newWarehouses';
  final String label = '仓库管理';
  final String iconType = "newWarehouses";
  final List<Menu> menus = [
    Menu(-1, 'newWarehouse', '新建仓库', 'newWarehouse'),
  ];
  Map<String, dynamic> toJson() {
    return {
      "cmd": cmd,
      "sort": sort,
      "label": label,
      "iconType": iconType,
      'menus': menus.map((e) => e.toJson()).toList()
    };
  }
}

/// 团队的操作
enum TeamOperates {
  pull(30, 'pull', '邀请成员', 'pull'),
  pullIdentity(31, 'pullIdentity', '添加角色', 'pullIdentity');

  const TeamOperates(
    this.sort,
    this.cmd,
    this.label,
    this.iconType,
  );

  final int sort;
  final String cmd;
  final String label;
  final String iconType;
  Map<String, dynamic> toJson() {
    return {
      "cmd": cmd,
      "sort": sort,
      "label": label,
      "iconType": iconType,
    };
  }

  static String getName(EntityOperates opreate) {
    return opreate.label;
  }
}

/// 用户的操作
enum TargetOperates {
  newCohort(32, 'newCohort', '设立群组', '群组'),
  newStorage(33, 'newStorage', '设立存储资源', '存储资源'),
  newCompany(34, 'newCompany', '设立单位', '单位'),
  newGroup(35, 'newGroup', '设立集群', '组织群'),
  newDepartment(36, 'newDepartment', '设立部门', '部门'),
  chat(15, 'openChat', '打开会话', '群组'),
  activate(15, 'activate', '激活存储', '激活');

  const TargetOperates(
    this.sort,
    this.cmd,
    this.label,
    this.iconType,
  );

  final int sort;
  final String cmd;
  final String label;
  final String iconType;
  Map<String, dynamic> toJson() {
    return {
      "cmd": cmd,
      "sort": sort,
      "label": label,
      "iconType": iconType,
    };
  }

  static String getName(EntityOperates opreate) {
    return opreate.label;
  }
}

///人员的申请
class PersonJoins {
  final int sort = 1;
  final String cmd = 'join';
  final String label = '申请加入';
  final String iconType = "join";
  final List<Menu> menus = [
    Menu(40, 'joinFriend', '添加好友', 'joinFriend'),
    Menu(41, 'joinCohort', '加入群组', 'joinCohort'),
    Menu(42, 'joinCompany', '加入单位', 'joinCompany'),
    Menu(43, 'joinStorage', '加入存储资源群', '存储资源'),
  ];
  Map<String, dynamic> toJson() {
    return {
      "cmd": cmd,
      "sort": sort,
      "label": label,
      "iconType": iconType,
      'menus': menus.map((e) => e.toJson()).toList()
    };
  }
}

///单位的申请
class CompanyJoins {
  final int sort = 1;
  final String cmd = 'join';
  final String label = '申请加入';
  final String iconType = "join";
  final List<Menu> menus = [
    Menu(42, 'joinGroup', '加入集群', 'joinGroup'),
    Menu(43, 'joinStorage', '加入存储资源群', '存储资源'),
  ];
  Map<String, dynamic> toJson() {
    return {
      "cmd": cmd,
      "sort": sort,
      "label": label,
      "iconType": iconType,
      'menus': menus.map((e) => e.toJson()).toList()
    };
  }
}

class Menu {
  final int sort;
  final String cmd;
  final String label;
  final String iconType;

  Menu(this.sort, this.cmd, this.label, this.iconType);
  Map<String, dynamic> toJson() {
    return {
      "cmd": cmd,
      "sort": sort,
      "label": label,
      "iconType": iconType,
    };
  }
}

/// 成员操作
enum MemberOperates {
  settingAuth(56, 'settingAuth', '权限设置', '权限'),
  settingIdentity(57, 'settingIdentity', '角色设置', '角色'),
  settingStation(58, 'settingStation', '岗位设置', '岗位'),
  copy(59, 'copy', '分配成员', 'copy'),
  remove(60, 'remove', '移除成员', 'remove'),
  exit(60, 'exit', '退出', 'exit');

  const MemberOperates(
    this.sort,
    this.cmd,
    this.label,
    this.iconType,
  );

  final int sort;
  final String cmd;
  final String label;
  final String iconType;
  Map<String, dynamic> toJson() {
    return {
      "cmd": cmd,
      "sort": sort,
      "label": label,
      "iconType": iconType,
    };
  }

  static String getName(EntityOperates opreate) {
    return opreate.label;
  }
}

/// 实体的操作
enum DirectoryAction {
  deleteMany,
  replaceMany
  // deleteMany('deleteMany'),
  // replaceMany('replaceMany');

  // const DirectoryAction(
  //   this.label,
  // );

  // final String label;

  // Map<String, dynamic> toJson() {
  //   return {
  //     "label": label,
  //   };
  // }

  // static String getName(EntityOperates opreate) {
  //   return opreate.label;
  // }
}
