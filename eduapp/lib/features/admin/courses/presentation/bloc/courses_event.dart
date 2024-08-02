import 'package:equatable/equatable.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object> get props => [];
}

class FetchAllCourses extends CourseEvent {}

class SearchCourses extends CourseEvent {
  final String query;

  const SearchCourses(this.query);

  @override
  List<Object> get props => [query];
}

class SelectCategory extends CourseEvent {
  final String category;

  const SelectCategory(this.category);

  @override
  List<Object> get props => [category];
}
