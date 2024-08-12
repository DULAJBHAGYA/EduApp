import 'package:equatable/equatable.dart';

abstract class AddMaterialsEvent extends Equatable {
  const AddMaterialsEvent();

  @override
  List<Object?> get props => [];
}

class FetchMaterialsByCourseId extends AddMaterialsEvent {
  final int course_id;

  const FetchMaterialsByCourseId({required this.course_id});

  @override
  List<Object?> get props => [course_id];
}
