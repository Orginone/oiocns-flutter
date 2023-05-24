


class TextReplaceUtils{
  static String replace(String text){
    String str = '';
    var findMe = RegExp(r'\$FINDME\[([^\]]*)\]');
    var citemessage = RegExp(r'\$CITEMESSAGE\[([^\]]*)\]');
    str = text.replaceAll(findMe, '');
    str = str.replaceAll(citemessage, '');
    return str;
  }

  static List<String> loadFindUserId(String text) {
    var findMe = RegExp(r'\$FINDME\[([^\]]*)\]');
    List<String> user =
        findMe.allMatches(text).map((e) => e.group(1) ?? "").toList();
    return user;
  }

  static String getReplyMsg(String text) {
    String msg = '';
    var reply = RegExp(r'\$CITEMESSAGE\[([^\]]*)\]');
    try {
      msg = reply.allMatches(text).map((e) => e.group(1) ?? "").first;
    } catch (e) {

    }
    return msg;
  }
}