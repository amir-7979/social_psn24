part of 'cooperation_bloc.dart';

abstract class CooperationState {}

class CooperationInitial extends CooperationState {}

class CooperationLoading extends CooperationState {}

class CooperationLoaded extends CooperationState {}

class CooperationSubmitted extends CooperationState {}

