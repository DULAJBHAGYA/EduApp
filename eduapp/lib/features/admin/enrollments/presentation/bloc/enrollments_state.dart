import 'package:equatable/equatable.dart';

abstract class EnrollmentsState extends Equatable {
  const EnrollmentsState();

  @override
  List<Object> get props => [];
}

class EnrollmentsInitial extends EnrollmentsState {}

class EnrollmentsLoading extends EnrollmentsState {}

class EnrollmentsLoaded extends EnrollmentsState {
  final List<dynamic> enrollments;

  const EnrollmentsLoaded(this.enrollments);

  @override
  List<Object> get props => [enrollments];
}

class EnrollmentActionSuccess extends EnrollmentsState {
  final String message;

  const EnrollmentActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class EnrollmentsError extends EnrollmentsState {
  final String error;

  const EnrollmentsError(this.error);

  @override
  List<Object> get props => [error];
}
