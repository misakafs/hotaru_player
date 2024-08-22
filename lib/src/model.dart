class EventMessage {
  String event;

  Map<String, dynamic>? data;

  EventMessage(
    this.event, {
    this.data,
  });

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
