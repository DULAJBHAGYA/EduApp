part of 'edit_course_bloc.dart';

sealed class EditCourseState extends Equatable {
  const EditCourseState();
  
  @override
  List<Object> get props => [];
}

final class EditCourseInitial extends EditCourseState {}
