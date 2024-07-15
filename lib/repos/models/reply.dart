import 'package:shamsi_date/shamsi_date.dart';

import 'sender.dart';

class Reply {
  final String? id;
  final String? message;
  final String? createdAt;
  final String? replyTo;
  final Sender? sender;
  final String? persianDate;

  Reply({this.id, this.message, this.createdAt, this.replyTo, this.sender, this.persianDate,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    String formattedPersianDate = '';
    String? createdAt = json['created_at'];
    if(createdAt == null){
      formattedPersianDate = '';
    }else {
      Jalali jalaliDate = Jalali.fromDateTime(DateTime.parse(createdAt));
      formattedPersianDate =
      '${jalaliDate.day} ${jalaliDate.formatter.mN} ${jalaliDate.year}';
    }
    return Reply(
      id: json['id'],
      message: json['message'],
      createdAt: json['created_at'],
      replyTo: json['reply_to'],
      sender: json['sender_id'] != null ? Sender.fromJson(json['sender_id']) : null,
      persianDate: formattedPersianDate,

    );
  }
}