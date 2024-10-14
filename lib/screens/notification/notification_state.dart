part of 'notification_bloc.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<MyNotification> notifications;
  final int unreadNotifications;
  NotificationLoaded(this.notifications, this.unreadNotifications);
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}