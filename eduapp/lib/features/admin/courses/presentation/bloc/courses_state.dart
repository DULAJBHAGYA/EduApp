import 'package:equatable/equatable.dart';

abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object> get props => [];
}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final List<dynamic> courses;
  final List<dynamic> filteredCourses;

  const CourseLoaded(this.courses, {this.filteredCourses = const []});

  @override
  List<Object> get props => [courses, filteredCourses];
}

class CourseError extends CourseState {
  final String message;

  const CourseError(this.message);

  @override
  List<Object> get props => [message];
}
