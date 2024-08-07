import 'package:equatable/equatable.dart';

abstract class AddCoursesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCoursesById extends AddCoursesEvent {}
