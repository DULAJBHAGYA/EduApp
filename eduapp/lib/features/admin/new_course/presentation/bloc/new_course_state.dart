import 'package:equatable/equatable.dart';

abstract class NewCourseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NewCourseInitial extends NewCourseState {}

class NewCourseLoading extends NewCourseState {}

class NewCourseLoaded extends NewCourseState {
  final int courseId;

  NewCourseLoaded(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class NewCourseError extends NewCourseState {
  final String error;

  NewCourseError(this.error);

  @override
  List<Object?> get props => [error];
}
