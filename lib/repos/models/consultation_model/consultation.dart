import 'package:social_psn/repos/models/consultation_model/user.dart';

import 'chat_info.dart';
import 'consultation_date.dart';
import 'consultation_type.dart';
import 'counseling_center.dart';

class Consultation {
  final int? id;
  final User? user;
  final User? consultant;
  final int? netTotal;
  final int? total;
  final String? statusPersian;
  final String? status;
  final ChatInfo? chatInfo;
  final ConsultationType? consultationType;
  final CounselingCenter? counselingCenter;
  final ConsultationDate? date;

  Consultation({
    this.id,
    this.user,
    this.consultant,
    this.netTotal,
    this.total,
    this.statusPersian,
    this.status,
    this.chatInfo,
    this.consultationType,
    this.counselingCenter,
    this.date,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'] as int?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      consultant: json['consultant'] != null ? User.fromJson(json['consultant']) : null,
      netTotal: json['net_total'] as int?,
      total: json['total'] as int?,
      statusPersian: json['status_persian'] as String?,
      status: json['status'] as String?,
      chatInfo: ChatInfo.fromJson(json['chat']),
      consultationType: json['consultation_type'] != null
          ? ConsultationType.fromJson(json['consultation_type'])
          : null,
      counselingCenter: json['counseling_center'] != null
          ? CounselingCenter.fromJson(json['counseling_center'])
          : null,
      date: json['date'] != null ? ConsultationDate.fromJson(json['date']) : null,
    );
  }
}
