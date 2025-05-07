import 'package:shamsi_date/shamsi_date.dart';

class RequestData {
  final int? id;
  final String? type;
  final String? title;
  final String? description;
  final String? comment;
  final String? status;
  final String? statusFa;
  final String? statusText;
  final String? createdAt;

  RequestData({
    this.id,
    this.type,
    this.title,
    this.description,
    this.comment,
    this.status,
    this.statusFa,
    this.statusText,
    this.createdAt,
  });

  factory RequestData.fromJson(Map<String, dynamic> json) {
    String formattedPersianDate = '';
    String? createdAt = json['created_at'].toString();
    Jalali jalaliDate = Jalali.fromDateTime(DateTime.parse(createdAt));
    formattedPersianDate =
    '${jalaliDate.day} ${jalaliDate.formatter.mN} ${jalaliDate.year}';
      return RequestData(
      id: json['id'] as int?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      comment: json['comment'] as String?,
      status: json['status'] as String?,
      statusFa: json['status_fa'] as String?,
      statusText: json['status_text'] as String?,
      createdAt: json['created_at'] != null
          ? formattedPersianDate
          : null,
    );
  }
}