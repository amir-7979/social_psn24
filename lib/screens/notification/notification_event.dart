part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {
  final String? contentId;
  final bool? seen;
  final int? targetId;

  LoadNotifications(this.contentId, this.seen, this.targetId);
}