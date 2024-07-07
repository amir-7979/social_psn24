part of 'post_bloc.dart';

@immutable
sealed class PostState {}

final class PostInitial extends PostState {}

class PostRefreshSuccess extends PostState {}

class InterestSuccessState extends PostState {}

class InterestFailureState extends PostState {}

class NotificationSuccessState extends PostState {}

class NotificationFailureState extends PostState {}


class UserVoteUpSuccessState extends PostState {}

class UserVoteUpFailureState extends PostState {}


class UserVoteDownSuccessState extends PostState {}

class UserVoteDownFailureState extends PostState {}

