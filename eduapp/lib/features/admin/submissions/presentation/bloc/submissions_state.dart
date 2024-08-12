import 'package:equatable/equatable.dart';

abstract class SubmissionsState extends Equatable {
  const SubmissionsState();

  @override
  List<Object> get props => [];
}

class SubmissionsInitial extends SubmissionsState {}

class SubmissionsLoading extends SubmissionsState {}

class SubmissionsLoaded extends SubmissionsState {
  final List<dynamic> submissions;

  const SubmissionsLoaded(this.submissions);

  @override
  List<Object> get props => [submissions];
}

class SubmissionsError extends SubmissionsState {
  final String message;

  const SubmissionsError(this.message);

  @override
  List<Object> get props => [message];
}
