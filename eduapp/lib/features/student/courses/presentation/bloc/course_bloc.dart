import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eduapp/features/student/courses/data/dataSources/course_service.dart';
import 'course_event.dart';
import 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc() : super(CourseInitial()) {
    on<FetchCourses>(_onFetchCourses);
    on<SearchCourses>(_onSearchCourses);
    on<SelectCategory>(_onSelectCategory);
  }

  Future<void> _onFetchCourses(
      FetchCourses event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    try {
      final courses = await CourseService.instance.fetchAllCourses();
      emit(CourseLoaded(courses ?? [], courses ?? []));
    } catch (e) {
      emit(CourseError('Failed to fetch courses'));
    }
  }

  void _onSearchCourses(SearchCourses event, Emitter<CourseState> emit) {
    if (state is CourseLoaded) {
      final loadedState = state as CourseLoaded;
      final filteredCourses = loadedState.courses.where((course) {
        final title = course['title'].toLowerCase();
        return title.contains(event.query.toLowerCase());
      }).toList();
      emit(CourseLoaded(loadedState.courses, filteredCourses));
    }
  }

  void _onSelectCategory(SelectCategory event, Emitter<CourseState> emit) {
    if (state is CourseLoaded) {
      final loadedState = state as CourseLoaded;
      final filteredCourses = loadedState.courses.where((course) {
        final category = course['catagory'].toLowerCase();
        return event.category == 'ALL COURSES' ||
            category == event.category.toLowerCase();
      }).toList();
      emit(CourseLoaded(loadedState.courses, filteredCourses));
    }
  }
}
