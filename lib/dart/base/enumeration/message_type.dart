enum MsgType {
  text("文本"),
  image("图片"),
  voice("语音"),
  video("视频"),
  recall("撤回"),
  file("文件"),
  read("已读"),
  pull("拉人");

  final String keyword;

  const MsgType(this.keyword);

  static String getName(MsgType msgType) {
    return msgType.keyword;
  }
}
