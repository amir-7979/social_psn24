import 'package:shamsi_date/shamsi_date.dart';

import 'consultant.dart';
import 'counseling_center_short.dart';

class ConsultantAvailability {
  final Consultant consultant;
  final AvailabilityData availabilities;

  ConsultantAvailability({
    required this.consultant,
    required this.availabilities,
  });

  factory ConsultantAvailability.fromJson(Map<String, dynamic> json) {
    final d = json['data'];
    return ConsultantAvailability(
      consultant: Consultant.fromJson(d['consultant']),
      availabilities: AvailabilityData.fromJson(d['availabilities']),
    );
  }
}

// Holds all consultation-type availabilities (in_person, video…)
class AvailabilityData {
  final List<CenterAvailability> inPerson;
  // you could add video/audio/chat similarly

  AvailabilityData({ required this.inPerson });

  factory AvailabilityData.fromJson(Map<String, dynamic> json) {
    final ip = json['in_person'];
    return AvailabilityData(
      inPerson: AvailabilityType.fromJson(ip).toCenterList(),
    );
  }
}

// Intermediate: raw list of centers + flat dates
class AvailabilityType {
  final List<CounselingCenterShort> centers;
  final List<RawAvailableDate> dates;

  AvailabilityType({ required this.centers, required this.dates });

  factory AvailabilityType.fromJson(Map<String, dynamic> json) {
    return AvailabilityType(
      centers: (json['counseling_centers'] as List)
          .map((e) => CounselingCenterShort.fromJson(e))
          .toList(),
      dates: (json['available_dates'] as List)
          .map((e) => RawAvailableDate.fromJson(e))
          .toList(),
    );
  }

  /// Group flat dates by center id → proper hierarchy
  List<CenterAvailability> toCenterList() {
    final map = <int, CenterAvailability>{};

    for (var raw in dates) {
      final centerJson = raw.counselingCenter;
      var c = map.putIfAbsent(
        centerJson.id!,
            () => CenterAvailability(
          center: centerJson,
          availableDates: [],
        ),
      );
      c.availableDates.add(
        AvailableDate.fromRaw(raw),
      );
    }

    return map.values.toList();
  }
}

/// The JSON‐parsing helper; you won’t need this elsewhere
class RawAvailableDate {
  final int id;
  final String date;           // e.g. "2025-05-17"
  final String jalaliDate;     // e.g. "1404-02-27"
  final CounselingCenterShort counselingCenter;
  final List<AvailableTime> times;

  RawAvailableDate({
    required this.id,
    required this.date,
    required this.jalaliDate,
    required this.counselingCenter,
    required this.times,
  });

  factory RawAvailableDate.fromJson(Map<String, dynamic> j) {
    String formattedPersianDate = '';
    String? createdAt = j['date'].toString();
    Jalali jalaliDate = Jalali.fromDateTime(DateTime.parse(createdAt));
    formattedPersianDate =
    '${jalaliDate.formatter.wN}\n${jalaliDate.day}\n${jalaliDate.formatter.mN}\n${jalaliDate.year}';
    return RawAvailableDate(
      id: j['id'],
      date: j['date'],
      jalaliDate: formattedPersianDate,
      counselingCenter:
      CounselingCenterShort.fromJson(j['counseling_center']),
      times: (j['available_times'] as List)
          .map((e) => AvailableTime.fromJson(e))
          .toList(),
    );
  }
}

/// Middle‐layer: groups a RawAvailableDate’s times into day-sections
class AvailableDate {
  final int id;
  final DateTime date;
  final String jalaliDate;
  final List<DaySectionAvailability> sections;

  AvailableDate({
    required this.id,
    required this.date,
    required this.jalaliDate,
    required this.sections,
  });

  factory AvailableDate.fromRaw(RawAvailableDate raw) {
    // parse the date string once
    final dt = DateTime.parse(raw.date);

    // group times by DaySection
    final buckets = <DaySection, List<AvailableTime>>{};
    for (var t in raw.times) {
      final section = DaySection.fromTimeString(t.time);
      buckets.putIfAbsent(section, () => []).add(t);
    }

    return AvailableDate(
      id: raw.id,
      date: dt,
      jalaliDate: raw.jalaliDate,
      sections: buckets.entries
          .map((e) => DaySectionAvailability(e.key, e.value))
          .toList(),
    );
  }
}

/// A single calendar center + its dates
class CenterAvailability {
  final CounselingCenterShort center;
  final List<AvailableDate> availableDates;

  CenterAvailability({
    required this.center,
    required this.availableDates,
  });
}

/// One time‐block section (e.g. day, evening, night)
class DaySectionAvailability {
  final DaySection section;
  final List<AvailableTime> times;

  DaySectionAvailability(this.section, this.times);
}

/// three buckets of the day
enum DaySection {
  day,    // 06:00–12:59
  evening,// 13:00–17:59
  night;  // 18:00–23:59 (you can include 00:00–05:59 here too)

  /// simple helper to decide where a “HH:mm” falls
  static DaySection fromTimeString(String hhmm) {
    final parts = hhmm.split(':').map(int.parse).toList();
    final h = parts[0];
    if (h >= 6 && h < 13) return DaySection.day;
    if (h >= 13 && h < 18) return DaySection.evening;
    return DaySection.night;
  }
}

/// exact same as your old AvailableTime
class AvailableTime {
  final int id;
  final String time;
  final String endTime;
  final int duration;

  AvailableTime({
    required this.id,
    required this.time,
    required this.endTime,
    required this.duration,
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
