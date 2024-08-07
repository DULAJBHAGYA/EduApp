import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class NewCourseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PickFileEvent extends NewCourseEvent {}

class SaveCourseEvent extends NewCourseEvent {
  final String title;
  final String description;
  final String category;
  final Map<String, dynamic> whatWillYouLearn;
  final Map<String, dynamic> skillsGained;
  final Map<String, dynamic> whoShouldLearn;
  final Uint8List? image;
  final int userId;

  SaveCourseEvent({
    required this.title,
    required this.description,
    required this.category,
    required this.whatWillYouLearn,
    required this.skillsGained,
    required this.whoShouldLearn,
    this.image,
    required this.userId,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        category,
        whatWillYouLearn,
        skillsGained,
        whoShouldLearn,
        image,
        userId,
      ];
}
