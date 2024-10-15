class HotaruPlayerOption {
  /// 控制条是否隐藏，默认：false
  final bool hideControls;

  /// 是否自动播放，默认：true
  final bool autoPlay;

  /// 是否循环播放，默认：false
  final bool loop;

  /// 开始播放位置，默认：0
  final Duration position;

  /// 播放地址，默认：''
  final String url;

  /// 播放封面，默认：''
  final String poster;

  const HotaruPlayerOption({
    this.hideControls = false,
    this.autoPlay = true,
    this.loop = false,
    this.position = Duration.zero,
    this.url = '',
    this.poster = '',
  });
}
