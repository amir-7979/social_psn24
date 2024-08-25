import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';

import '../../repos/models/notification.dart';
import '../../repos/repositories/graphql/setting_repository.dart';
import '../../services/graphql_service.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GraphQLClient graphQLService = GraphQLService.instance.client;

  NotificationBloc() : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotificationsEvent);
  }

Future<void> _onLoadNotificationsEvent(LoadNotifications event, Emitter<NotificationState> emit) async {
  emit(NotificationLoading());
  try {
    final QueryOptions options = getNotifications(event.contentId, event.seen, event.targetId);
    final QueryResult result = await graphQLService.query(options);
    print('result: ${result.data}');
    if (result.hasException) {
      emit(NotificationError(result.exception.toString()));
    } else {
      List<MyNotification> notifications = (result.data!['notifications'] as List)
          .map((notification) => MyNotification.fromJson(notification))
          .toList();
      emit(NotificationLoaded(notifications));
    }
  } catch (exception) {
    emit(NotificationError(exception.toString()));
  }
}}