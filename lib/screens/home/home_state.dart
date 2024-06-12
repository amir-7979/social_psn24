part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class PostRefreshSuccess extends HomeState {}

class InterestSuccessState extends HomeState {}

class InterestFailureState extends HomeState {}

class NotificationSuccessState extends HomeState {}

class NotificationFailureState extends HomeState {}