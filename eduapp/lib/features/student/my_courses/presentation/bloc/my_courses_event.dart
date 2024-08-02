// my_courses_event.dart
import 'package:equatable/equatable.dart';

abstract class MyCoursesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchOngoingCourses extends MyCoursesEvent {
  add(FetchCompletedCourses fetchCompletedCourses) {}
}

class FetchCompletedCourses extends MyCoursesEvent {}
