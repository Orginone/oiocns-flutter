import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/public/enums.dart';

// 异常消息常量
const unAuthorizedError = '抱歉,您没有权限操作.';
const isExistError = '抱歉,已存在请勿重复创建.';
const resultError = '抱歉,请求返回异常.';
const notFoundError = '抱歉,未找到该数据.';
const isJoinedError = '抱歉,您已加入该组织.';
const functionNotFoundError = '抱歉,未找到该方法.';

///资产共享云模块权限Id
enum OrgAuth {
  // 超管权限
  superAuthId("361356410044420096"),
  // 关系管理权限
  relationAuthId("361356410623234048"),
  // 物，标准等管理权限
  thingAuthId("361356410698731520"),
  // 办事管理权限
  workAuthId("361356410774228992");

  final String label;
  const OrgAuth(this.label);
}

///数据存储集合名称
const storeCollName = {
  'workTask': 'work-task',
  'workInstance': 'work-instances',
  'chatMessage': 'chat-message',
  'transfer': 'standard-transfer',
};

///支持的单位类型
const companyTypes = [
  TargetType.company,
  TargetType.hospital,
  TargetType.university,
];

///支持的单位部门类型
const departmentTypes = [
  TargetType.college,
  TargetType.department,
  TargetType.office,
  TargetType.section,
  TargetType.major,
  TargetType.working,
  TargetType.research,
  TargetType.laboratory,
];

///支持的值类型
const valueType = [
  ValueType.number,
  ValueType.remark,
  ValueType.select,
  ValueType.species,
  ValueType.time,
  ValueType.target,
  ValueType.date,
  ValueType.file,
];

const targetDepartmentTypes = [
  TargetType.office,
  TargetType.section,
  TargetType.research,
  TargetType.laboratory,
  TargetType.jobCohort,
  TargetType.department,
];

const subDepartmentTypes = [
  TargetType.office,
  TargetType.section,
  TargetType.laboratory,
  TargetType.jobCohort,
  TargetType.research,
];
List<PopupMenuKey> createPopupMenuKey = [
  PopupMenuKey.createDir,
  PopupMenuKey.createApplication,
  PopupMenuKey.createSpecies,
  PopupMenuKey.createDict,
  PopupMenuKey.createAttr,
  PopupMenuKey.createThing,
  PopupMenuKey.createWork,
];

List<PopupMenuKey> defaultPopupMenuKey = [
  PopupMenuKey.upload,
  PopupMenuKey.openChat,
  PopupMenuKey.shareQr,
];

///表达弹框支持的类型
enum FormModalType {
  // ignore: constant_identifier_names
  New("New"),
  edit("Edit"),
  view("View");

  final String label;
  const FormModalType(this.label);
}

///用于获取全部的分页模型
final pageAll = PageModel(
  offset: 0,
  limit: (2 << 15) - 1, //ushort.max
  filter: '',
);

///通用状态信息Map
class Status {
  String color;
  String text;

  Status({required this.color, required this.text});
}

final Map<int, Status> StatusMap = {
  1: Status(color: 'blue', text: '待处理'),
  100: Status(color: 'green', text: '已同意'),
  200: Status(color: 'red', text: '已拒绝'),
  102: Status(color: 'green', text: '已发货'),
  220: Status(color: 'green', text: '已取消'),
};

var ShareIdSet = <String, ShareIcon>{};
