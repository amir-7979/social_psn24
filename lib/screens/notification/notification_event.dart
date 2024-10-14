part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {}
class AllNotificationsMarked extends NotificationEvent {}
class NotificationMarked extends NotificationEvent {
  final String notificationId;
  NotificationMarked(this.notificationId);
}

