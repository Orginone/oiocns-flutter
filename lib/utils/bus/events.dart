//输入表格清空事件 用于清空输入框
//传递 index 数组 用于区分是哪个输入框
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message.dart';
import 'package:orginone/dart/core/target/base/target.dart';

class InputFormClearEvent {
  List<int> indexs;
  int focusIndex; //清空后需要聚焦的输入框
  String tag;
  InputFormClearEvent(
      {required this.indexs, required this.focusIndex, required this.tag});
}

//接收到服务端消息
class ReceiveEvent {
  String eventName;
  dynamic data;
  ReceiveEvent({required this.eventName, required this.data});
}

//加载待办事件
class LoadTodosEvent {}

class CheckReload {}

class ChoicePeople {
  late XTarget user;
  late ITarget department;

  ChoicePeople({required this.user, required this.department});
}

class ChoiceDepartment {
  late ITarget department;

  ChoiceDepartment({required this.department});
}

class InitDataDone {}

class ShowLoading {
  final bool isShow;

  ShowLoading(this.isShow);
}

class StartLoad {}

class LoadUserDone {}

class LoadApplicationDone {}

class LoadAssets {}

class JumpSpecifyMessage {
  late IMessage message;

  JumpSpecifyMessage(this.message);
}

class WorkReload {}

class User {
  late Map<String, dynamic> person;
  User(this.person);
}

class SignOut {}

class UserLoaded {}
