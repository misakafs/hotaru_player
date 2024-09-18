class EventMessage {
  String event;

  Map<String, dynamic>? data;

  EventMessage(
    this.event, {
    this.data,
  });

  /// 初始化
  /// { "url": "播放地址", "autoplay": true }
  factory EventMessage.init(Map<String, dynamic>? data) {
    return EventMessage('init', data: data);
  }

  /// 播放
  /// { "url": "播放地址", "poster": "封面" }
  factory EventMessage.play(Map<String, dynamic>? data) {
    return EventMessage('play', data: data);
  }

  factory EventMessage.fromJson(Map<String, dynamic> m) {
    return EventMessage(
      m['event'] as String,
      data: m['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'data': data,
    };
  }
}
