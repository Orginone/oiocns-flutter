enum ChatType {
  self("本人"),
  colleague("同事"),
  group("群组"),
  friends("好友"),
  unit("单位"),
  unknown("未知");

  final String label;

  const ChatType(this.label);

  static String getName(ChatType chatType) {
    return chatType.label;
  }
}
