import 'package:shamsi_date/shamsi_date.dart';

import 'notification_item_data.dart';
import 'notification_sender.dart';

class MyNotification {
  final String? id;
  final int? user;
  final NotificationSender? sender;
  final String? title;
  final String? body;
  final String? icon;
  final String? image;
  final NotificationDataDetails? data;
  final String? service;
  final int? seen;
  final String? createdAt;

  MyNotification({
    this.id,
    this.user,
    this.sender,
    this.title,
    this.body,
    this.icon,
    this.image,
    this.data,
    this.service,
    this.seen,
    this.createdAt,
  });

  factory MyNotification.fromJson(Map<String, dynamic> json) {
    String? createdAt = json['created_at'];
    Jalali? jalaliDate = createdAt != null ? Jalali.fromDateTime(DateTime.parse(createdAt)) : null;
    String? formattedPersianDate = jalaliDate != null ? '${jalaliDate.day} ${jalaliDate.formatter.mN} ${jalaliDate.year}' : null;

    return MyNotification(
      id: json['id'],
      user: json['user'],
      sender: json['sender'] != null ? NotificationSender.fromJson(json['sender']) : null,
      title: json['title'],
      body: json['body'],
      icon: json['icon'],
      image: json['image'],
      data: json['data'] != null ? NotificationDataDetails.fromJson(json['data']) : null,
      service: json['service'],
      seen: json['seen'],
      createdAt: formattedPersianDate,
    );
  }
}