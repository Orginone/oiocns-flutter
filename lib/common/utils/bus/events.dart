//输入表格清空事件 用于清空输入框
//传递 index 数组 用于区分是哪个输入框
class InputFormClearEvent {
  List<int> indexs;
  int focusIndex; //清空后需要聚焦的输入框
  String tag;
  InputFormClearEvent(
      {required this.indexs, required this.focusIndex, required this.tag});
}
