import 'package:equatable/equatable.dart';

abstract class AddCoursesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddCoursesInitial extends AddCoursesState {}

class AddCoursesLoading extends AddCoursesState {}

class AddCoursesLoaded extends AddCoursesState {
  final List<dynamic> addedCourses;

  AddCoursesLoaded({required this.addedCourses});

  @override
  List<Object?> get props => [addedCourses];
}

class AddCoursesError extends AddCoursesState {
  final String message;

  AddCoursesError(this.message);

  @override
  List<Object?> get props => [message];
}
