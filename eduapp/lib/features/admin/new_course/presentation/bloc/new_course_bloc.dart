import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:eduapp/features/admin/new_course/data/dataSources/course_service.dart';
import 'package:eduapp/features/admin/new_course/presentation/bloc/new_course_event.dart';
import 'package:eduapp/features/admin/new_course/presentation/bloc/new_course_state.dart';
import 'package:dio/dio.dart';

class NewCourseBloc extends Bloc<NewCourseEvent, NewCourseState> {
  NewCourseBloc() : super(NewCourseInitial()) {
    on<SaveCourseEvent>(_onSaveCourseEvent);
  }

  void _onSaveCourseEvent(
      SaveCourseEvent event, Emitter<NewCourseState> emit) async {
    emit(NewCourseLoading());
    try {
      final FormData formData = FormData.fromMap({
        'user_id': event.userId,
        'title': event.title,
        'description': event.description,
        'catagory': event.category,
        'image': event.image != null
            ? MultipartFile.fromBytes(event.image!, filename: 'image.jpg')
            : null,
        'what_will': jsonEncode(event.whatWillYouLearn),
        'what_skil_you_gain': jsonEncode(event.skillsGained),
        'who_should_learn': jsonEncode(event.whoShouldLearn),
      });

      final response =
          await CourseService.instance.postCourse(formData, event.userId);

      if (response != null &&
          response.containsKey('course_id') &&
          response['course_id'] != null) {
        final courseId = int.parse(response['course_id'].toString());
        emit(NewCourseLoaded(courseId));
      } else {
        emit(NewCourseError("Course ID not found in the response"));
      }
    } catch (e) {
      emit(NewCourseError('Error: $e'));
    }
  }
}
