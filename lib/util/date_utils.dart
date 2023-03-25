import 'package:intl/intl.dart';


class LPDateUtils {
  static int getNowMs() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static bool compareHours(int time1, int time2, int hours) {
    var dValue = (time1 - time2).abs();
    if (dValue > hours * 3600 * 1000) {
      return true;
    } else {
      return false;
    }
  }

  static bool beforeMonth({required DateTime current, required DateTime max}) {
    if (current.year < max.year) {
      return true;
    }else if (current.year == max.year) {
      if(current.month < max.month){
        return true;
      }
    }
    return false;
  }

  static bool afterMonth({required DateTime current, required DateTime min}) {
    if (current.year > min.year) {
      return true;
    }else if (current.year == min.year) {
      if(current.month > min.month){
        return true;
      }
    }
    return false;
  }

  /// 获取本月第一天
  static DateTime getMonthFirstDay({DateTime? date}) {
    if(date == null){
      date = DateTime.now();
    }
    return DateTime(date.year, date.month, 1);
  }

  /// 获取本月最后一天
  static DateTime getMonthLastDay({DateTime? date}) {
    if(date == null){
      date = DateTime.now();
    }
    int d = getDayCounts(date.month);
    return DateTime(date.year, date.month, d)
        .add(Duration(days: 1, minutes: -1,seconds: 59));
  }

  /// 获取一个月有多少天
  static int getDayCounts(int month) {
    int year = DateTime.now().year;
    int end = 0;
    if (month == 1) {
      end = 31;
    } else if (month == 2) {
      if ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0)) {
        end = 29;
      } else {
        end = 28;
      }
    } else if (month == 3) {
      end = 31;
    } else if (month == 4) {
      end = 30;
    } else if (month == 5) {
      end = 31;
    } else if (month == 6) {
      end = 30;
    } else if (month == 7) {
      end = 31;
    } else if (month == 8) {
      end = 31;
    } else if (month == 9) {
      end = 30;
    } else if (month == 10) {
      end = 31;
    } else if (month == 11) {
      end = 30;
    } else if (month == 12) {
      end = 31;
    }
    return end;
  }
}

extension RemoveSpace on String {
  String get removeSpace {
    if (this == null || this.isEmpty) {
      return this;
    }
    String breakWord = '';
    this.runes.forEach((element) {
      breakWord += String.fromCharCode(element);
      breakWord += '\u200B';
    });
    return breakWord;
  }
}

extension Format on DateTime {
  String format({String format = "yyyy-MM-dd"}) {
     if(this == null){
       return "";
     }
    return DateFormat(format, "zh_CN").format(this);
  }

  String toNoUsIso8601String() {
    String y =
        (year >= -9999 && year <= 9999) ? _fourDigits(year) : _sixDigits(year);
    String m = _twoDigits(month);
    String d = _twoDigits(day);
    String h = _twoDigits(hour);
    String min = _twoDigits(minute);
    String sec = _twoDigits(second);
    String ms = _threeDigits(millisecond);
    if (isUtc) {
      return "$y-$m-${d}T$h:$min:$sec.${ms}Z";
    } else {
      return "$y-$m-${d}T$h:$min:$sec.$ms";
    }
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
  }

  static String _threeDigits(int n) {
    if (n >= 100) return "${n}";
    if (n >= 10) return "0${n}";
    return "00${n}";
  }

  static String _fourDigits(int n) {
    int absN = n.abs();
    String sign = n < 0 ? "-" : "";
    if (absN >= 1000) return "$n";
    if (absN >= 100) return "${sign}0$absN";
    if (absN >= 10) return "${sign}00$absN";
    return "${sign}000$absN";
  }

  static String _sixDigits(int n) {
    assert(n < -9999 || n > 9999);
    int absN = n.abs();
    String sign = n < 0 ? "-" : "+";
    if (absN >= 100000) return "$sign$absN";
    return "${sign}0$absN";
  }
}
