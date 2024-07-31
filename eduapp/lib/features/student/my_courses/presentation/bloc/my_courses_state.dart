// my_courses_state.dart
import 'package:equatable/equatable.dart';

abstract class MyCoursesState extends Equatable {
  @override
  List<Object> get props => [];
}

class MyCoursesInitial extends MyCoursesState {}

class MyCoursesLoading extends MyCoursesState {}

class OngoingCoursesFetched extends MyCoursesState {
  final int count;

  OngoingCoursesFetched(this.count);

  @override
  List<Object> get props => [count];
}

class CompletedCoursesFetched extends MyCoursesState {
  final int count;

  CompletedCoursesFetched(this.count);

  @override
  List<Object> get props => [count];
}

class MyCoursesError extends MyCoursesState {
  final String message;

  MyCoursesError(this.message);

  @override
  List<Object> get props => [message];
}
