
import 'package:shamsi_date/shamsi_date.dart';

import 'consultant.dart';
import 'counseling_center_short.dart';

class ConsultantAvailability {
  final Consultant? consultant;
  final AvailabilityData? availabilities;

  ConsultantAvailability({
    this.consultant,
    this.availabilities,
  });

  factory ConsultantAvailability.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return ConsultantAvailability(
      consultant: data['consultant'] != null
          ? Consultant.fromJson(data['consultant'])
          : null,
      availabilities: data['availabilities'] != null
          ? AvailabilityData.fromJson(data['availabilities'])
          : null,
    );
  }
}

class AvailabilityData {
  final AvailabilityType? inPerson;
  final AvailabilityType? video;
  final AvailabilityType? audio;
  final AvailabilityType? chat;

  AvailabilityData({this.inPerson, this.video, this.audio, this.chat});

  factory AvailabilityData.fromJson(Map<String, dynamic> json) {
    return AvailabilityData(
      inPerson: json['in_person'] != null
          ? AvailabilityType.fromJson(json['in_person'])
          : null,
      video: json['video'] != null
          ? AvailabilityType.fromJson(json['video'])
          : null,
      audio: json['audio'] != null
          ? AvailabilityType.fromJson(json['audio'])
          : null,
      chat: json['chat'] != null
          ? AvailabilityType.fromJson(json['chat'])
          : null,
    );
  }
}

class AvailabilityType {
  final List<CounselingCenterShort>? counselingCenters;
  final List<AvailableDate>? availableDates;

  AvailabilityType({
    this.counselingCenters,
    this.availableDates,
  });

  factory AvailabilityType.fromJson(Map<String, dynamic> json) {

    return AvailabilityType(
      counselingCenters: (json['counseling_centers'] as List<dynamic>?)
          ?.map((e) => CounselingCenterShort.fromJson(e))
          .toList(),
      availableDates: (json['available_dates'] as List<dynamic>?)
          ?.map((e) => AvailableDate.fromJson(e))
          .toList(),
    );
  }
}

class AvailableDate {
  final int? id;
  final String? date;
  final String? jalaliDate;
  final CounselingCenterShort? counselingCenter;
  final List<AvailableTime>? availableTimes;
  String? formattedPersianDate;

  AvailableDate({
    this.id,
    this.date,
    this.jalaliDate,
    this.counselingCenter,
    this.availableTimes,
    this.formattedPersianDate
  });

  factory AvailableDate.fromJson(Map<String, dynamic> json) {
    String formattedPersianDate = '';
    String? createdAt = json['date'].toString();
    Jalali jalaliDate = Jalali.fromDateTime(DateTime.parse(createdAt));
    formattedPersianDate =
    '${jalaliDate.formatter.wN}\n${jalaliDate.day}\n${jalaliDate.formatter.mN}\n${jalaliDate.year}';

    return AvailableDate(
      id: json['id'],
      date: json['date'],
      jalaliDate: json['jalali_date'],
      counselingCenter: json['counseling_center'] != null
          ? CounselingCenterShort.fromJson(json['counseling_center'])
          : null,
      availableTimes: (json['available_times'] as List<dynamic>?)
          ?.map((e) => AvailableTime.fromJson(e))
          .toList(),
      formattedPersianDate: formattedPersianDate,
    );
  }
}

class AvailableTime {
  final int? id;
  final String? time;
  final String? endTime;
  final int? duration;

  AvailableTime({
    this.id,
    this.time,
    this.endTime,
    this.duration,
  });

  factory AvailableTime.fromJson(Map<String, dynamic> json) {
    return AvailableTime(
      id: json['id'],
      time: json['time'],
      endTime: json['end_time'],
      duration: json['duration'],
    );
  }
}
