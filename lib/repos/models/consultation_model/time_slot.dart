class TimeSlot {
  final int? id;
  final String? time;
  final String? endTime;
  final int? duration;

  TimeSlot({this.id, this.time, this.endTime, this.duration});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'] as int?,
      time: json['time'] as String?,
      endTime: json['end_time'] as String?,
      duration: json['duration'] as int?,
    );
  }
}
