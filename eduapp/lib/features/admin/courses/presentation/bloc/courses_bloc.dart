import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduapp/features/admin/courses/data/dataServices/course_service.dart';

import 'courses_event.dart';
import 'courses_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc() : super(CourseLoading()) {
    on<FetchCourses>((event, emit) async {
      emit(CourseLoading());
      try {
        final courses = await CourseService.instance.fetchAllCourses();
        emit(CourseLoaded(courses ?? []));
      } catch (e) {
        emit(CourseError('Failed to load courses'));
      }
    });

    on<FilterCourses>((event, emit) {
      if (state is CourseLoaded) {
        final loadedState = state as CourseLoaded;
        final filteredCourses = loadedState.courses.where((course) {
          final title = course['title'].toLowerCase();
          return title.startsWith(event.query);
        }).toList();
        emit(CourseLoaded(loadedState.courses,
            filteredCourses: filteredCourses));
      }
    });
  }
}
