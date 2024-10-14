import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/src/response.dart';
import 'package:meta/meta.dart';
import '../../repos/models/notification.dart';
import '../../repos/repositories/dio/dio_notification_repository.dart';


part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  List<MyNotification> notifications = [];
  int unreadNotifications = 0;
  final NotificationRepository _notificationRepository = NotificationRepository();

  NotificationBloc() : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotificationsEvent);
    on<AllNotificationsMarked>(_onAllMarkAsReadEvent);
    on<NotificationMarked>(_onNotificationMarkedEvent);
  }

  Future<void> _onLoadNotificationsEvent(
      LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      Response result = await _notificationRepository.fetchNotifications();
        notifications = (result.data!['data']['notifications'] as List)
            .map((notification) => MyNotification.fromJson(notification))
            .toList();
      checkUnreadNotifications();
        emit(NotificationLoaded(notifications, unreadNotifications));
    } catch (exception) {
      emit(NotificationError(exception.toString()));
    }
  }

  Future<void> _onAllMarkAsReadEvent(AllNotificationsMarked event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      await _notificationRepository.markAllNotificationsAsRead();
      Response result = await _notificationRepository.fetchNotifications();
      notifications = (result.data!['data']['notifications'] as List)
          .map((notification) => MyNotification.fromJson(notification))
          .toList();
      checkUnreadNotifications();
      emit(NotificationLoaded(notifications, unreadNotifications));
    } catch (exception) {
      print(exception.toString());
      emit(NotificationError(exception.toString()));
    }
  }

  //i  need a function to check if there is unreadNotifications or not.
  void checkUnreadNotifications() {
    unreadNotifications = notifications.where((element) => element.seen == 0).length;
    if (unreadNotifications > 99) {
      unreadNotifications = 99;
    }
  }


  Future<void> _onNotificationMarkedEvent(NotificationMarked event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      await _notificationRepository.markNotificationAsRead(event.notificationId);
      Response result = await _notificationRepository.fetchNotifications();
      notifications = (result.data!['data']['notifications'] as List)
          .map((notification) => MyNotification.fromJson(notification))
          .toList();
      checkUnreadNotifications();
      emit(NotificationLoaded(notifications, unreadNotifications));
    } catch (exception) {
      print(exception.toString());
      emit(NotificationError(exception.toString()));
    }
  }
}
