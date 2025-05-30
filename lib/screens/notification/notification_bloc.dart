import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/src/response.dart';
import 'package:meta/meta.dart';
import '../../repos/models/notification.dart';
import '../../repos/repositories/dio/notification_repository.dart';


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
      print(exception.toString());
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

  void checkUnreadNotifications() {
    unreadNotifications = notifications.where((element) => element.seen == 0).length;
    if (unreadNotifications > 99) {
      unreadNotifications = 99;
    }
    List<MyNotification> unread = notifications.where((element) => element.seen == 0).toList();
    List<MyNotification> read = notifications.where((element) => element.seen == 1).toList();
    notifications = [...unread, ...read];
  }

  //reset bloc variables
  void reset() {
    notifications = [];
    unreadNotifications = 0;
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
