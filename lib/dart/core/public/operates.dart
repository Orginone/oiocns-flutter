import 'package:orginone/dart/base/model.dart';

///web端的翻译，用于鼠标右键功能，移动端暂时不实现
///实体的操作
enum entityOperates OperateModel{
  open(),
  update(),
  delete(),
  remark(),
  qrCode(),
}

///文件支持的操作
enum fileOperates {
  download(),
  copy(),
  move(),
  parse(),
  rename();
}

///目录支持的操作
enum directoryOperates {
  refresh(),
  newFile(),
  taskList(),
  newDir(),
  newApp(),
  standard(),
  newSpecies(),
  newDict(),
  newProperty(),
  newWork(),
  newModule(),
  newThingConfig(),
  newWorkConfig();
}

///目录下新增(重新整理再进行翻译)

///团队的操作
enum teamOperates {
  pull(),
  pullIdentity();
}

///用户的操作
enum targetOperates {
  newCohort(),
  newStorage(),
  newCompany(),
  newGroup(),
  newDepartment(),
  chat(),
  activate();
}

///人员的申请(重新整理再进行翻译)

///单位的申请(重新整理再进行翻译)

///成员操作
enum memberOperates {
  settingsAuth(),
  settingIdentity(),
  settingStation(),
  copy(),
  remove(),
  exit();
}
