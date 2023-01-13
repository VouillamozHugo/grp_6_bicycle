class StringFormater {
  String calculateDistance(int dist) {
    if (dist > 999) {
      return "${(dist / 1000).toStringAsFixed(1)} km";
    }
    return "$dist m";
  }

  String calculateTime(int time) {
    int seconde = time;
    int day = (seconde / 86400).floor();
    seconde = seconde - day * 86400;
    int hour = (seconde / 3600).floor();
    seconde = seconde - hour * 3600;
    int minute = (seconde / 60).floor();
    seconde = seconde - minute * 60;
    if (day > 0) {
      return "${day}d${hour + (minute >= 30 ? 1 : 0)}hrs";
    }
    if (hour > 0) {
      minute = minute + (seconde >= 30 ? 1 : 0);
      return "${hour}h${minute < 10 ? "0" : ""}$minute";
    }
    if (minute > 0) {
      return "${minute}m${seconde < 10 ? "0" : ""}$seconde";
    }
    return "${seconde}sec";
  }
}
