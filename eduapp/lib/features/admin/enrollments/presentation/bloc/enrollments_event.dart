import 'package:equatable/equatable.dart';

abstract class EnrollmentsEvent extends Equatable {
  const EnrollmentsEvent();

  @override
  List<Object> get props => [];
}

class FetchEnrollments extends EnrollmentsEvent {}

class AcceptEnrollRequest extends EnrollmentsEvent {
  final int userId;
  final int courseId;

  const AcceptEnrollRequest(this.userId, this.courseId);

  @override
  List<Object> get props => [userId, courseId];
}

class DeclineEnrollRequest extends EnrollmentsEvent {
  final int userId;
  final int courseId;

  const DeclineEnrollRequest(this.userId, this.courseId);

  @override
  List<Object> get props => [userId, courseId];
}
