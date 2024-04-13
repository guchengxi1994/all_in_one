import 'package:lunar/lunar.dart';

extension ToStr on Lunar {
  String toFormatString() {
    String s = '';
    s += toString();
    s += '\n';
    s += getYearInGanZhi();
    s += '(';
    s += getYearShengXiao();
    s += ')年 ';
    s += getMonthInGanZhi();
    s += '(';
    s += getMonthShengXiao();
    s += ')月 ';
    s += getDayInGanZhi();
    s += '(';
    s += getDayShengXiao();
    s += ')日 ';
    s += getTimeZhi();
    s += '(';
    s += getTimeShengXiao();
    s += ')时 纳音[';
    s += getYearNaYin();
    s += ' ';
    s += getMonthNaYin();
    s += ' ';
    s += getDayNaYin();
    s += ' ';
    s += getTimeNaYin();
    s += '] 星期';
    s += getWeekInChinese();
    for (String f in getFestivals()) {
      s += '\n(';
      s += f;
      s += ')';
    }
    for (String f in getOtherFestivals()) {
      s += '\n(';
      s += f;
      s += ')';
    }
    String jq = getJieQi();
    if (jq.isNotEmpty) {
      s += '\n[';
      s += jq;
      s += ']';
    }
    s += '\n';
    s += getGong();
    s += '方';
    s += getShou();
    s += ' 星宿[';
    s += getXiu();
    s += getZheng();
    s += getAnimal();
    s += '](';
    s += getXiuLuck();
    s += ')\n彭祖百忌[';
    s += getPengZuGan();
    s += ' ';
    s += getPengZuZhi();
    s += ']\n喜神方位[';
    s += getDayPositionXi();
    s += '](';
    s += getDayPositionXiDesc();
    s += ')\n阳贵神方位[';
    s += getDayPositionYangGui();
    s += '](';
    s += getDayPositionYangGuiDesc();
    s += ')\n阴贵神方位[';
    s += getDayPositionYinGui();
    s += '](';
    s += getDayPositionYinGuiDesc();
    s += ')\n福神方位[';
    s += getDayPositionFu();
    s += '](';
    s += getDayPositionFuDesc();
    s += ')\n财神方位[';
    s += getDayPositionCai();
    s += '](';
    s += getDayPositionCaiDesc();
    s += ')\n冲[';
    s += getDayChongDesc();
    s += '] 煞[';
    s += getDaySha();
    s += ']';
    return s;
  }
}
