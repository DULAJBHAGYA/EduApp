import 'package:equatable/equatable.dart';

abstract class CourseDescriptionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCourseDetails extends CourseDescriptionEvent {
  final int courseId;

  FetchCourseDetails(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class FetchUserById extends CourseDescriptionEvent {
  int get courseId => courseId;
}

class FetchMaterialCountByCourseId extends CourseDescriptionEvent {
  final int courseId;

  FetchMaterialCountByCourseId(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class FetchStudentCountByCourseId extends CourseDescriptionEvent {
  final int courseId;

  FetchStudentCountByCourseId(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class GetMaterialByCourseId extends CourseDescriptionEvent {
  final int courseId;

  GetMaterialByCourseId(this.courseId);

  @override
  List<Object?> get props => [courseId];
}
