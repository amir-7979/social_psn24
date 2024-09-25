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
  final NotificationRepository _notificationRepository = NotificationRepository();

  NotificationBloc() : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotificationsEvent);
    on<NotificationsMarked>(_onMarkAsReadEvent);
    on<AddNotification>(_onAddNotification);
    on<ClearNotifications>(_onAddNotifications);
  }

  Future<void> _onLoadNotificationsEvent(
      LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      Response result = await _notificationRepository.fetchNotifications();
        notifications = (result.data!['data']['notifications'] as List)
            .map((notification) => MyNotification.fromJson(notification))
            .toList();
        emit(NotificationLoaded(notifications));
    } catch (exception) {
      emit(NotificationError(exception.toString()));
    }
  }

  Future<FutureOr<void>> _onMarkAsReadEvent(NotificationsMarked event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      await _notificationRepository.markAsRead();
      Response result = await _notificationRepository.fetchNotifications();
      print(result.toString());
      notifications = (result.data!['data']['notifications'] as List)
          .map((notification) => MyNotification.fromJson(notification))
          .toList();
      emit(NotificationLoaded(notifications));
    } catch (exception) {
      print(exception.toString());
      emit(NotificationError(exception.toString()));
    }
  }

  FutureOr<void> _onAddNotification(AddNotification event, Emitter<NotificationState> emit) {
  }

  FutureOr<void> _onAddNotifications(ClearNotifications event, Emitter<NotificationState> emit) {
  }
}
