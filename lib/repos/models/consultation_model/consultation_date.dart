import 'counseling_center_short.dart';
import 'time_slot.dart';

class ConsultationDate {
  final int? id;
  final String? date;
  final String? jalaliDate;
  final CounselingCenterShort? counselingCenter;
  final TimeSlot? time;

  ConsultationDate({
    this.id,
    this.date,
    this.jalaliDate,
    this.counselingCenter,
    this.time,
  });

  factory ConsultationDate.fromJson(Map<String, dynamic> json) {
    return ConsultationDate(
      id: json['id'] as int?,
      date: json['date'] as String?,
      jalaliDate: json['jalali_date'] as String?,
      counselingCenter: json['counseling_center'] != null
          ? CounselingCenterShort.fromJson(json['counseling_center'])
          : null,
      time: json['time'] != null ? TimeSlot.fromJson(json['time']) : null,
    );
  }
}
