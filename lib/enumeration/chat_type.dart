enum ChatType {
  self("本人"),
  colleague("同事"),
  group("群组"),
  friends("好友"),
  unit("单位"),
  unknown("未知");

  final String name;

  const ChatType(this.name);

  static String getName(ChatType chatType) {
    return chatType.name;
  }
}
