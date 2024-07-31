import 'package:equatable/equatable.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object> get props => [];
}

class FetchCourses extends CourseEvent {}

class FilterCourses extends CourseEvent {
  final String query;

  const FilterCourses(this.query);

  @override
  List<Object> get props => [query];
}
