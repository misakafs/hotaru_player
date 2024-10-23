class HotaruUtils {
  /// 格式化时间
  static String formatDuration(Duration duration, bool exceedHour) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    if (exceedHour || hours > 0) {
      // 格式化输出时:分:秒
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      // 格式化输出分:秒
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
