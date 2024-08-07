import 'package:flutter_bloc/flutter_bloc.dart';
import 'course_desc_event.dart';
import 'package:eduapp/features/student/course_desc/data/dataSources/count_service.dart';
import 'package:eduapp/features/student/course_desc/data/dataSources/course_service.dart';
import 'package:eduapp/features/student/course_desc/data/dataSources/enroll_service.dart';
import 'package:eduapp/features/student/course_desc/data/dataSources/material_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'course_desc_state.dart';

class CourseDescriptionBloc
    extends Bloc<CourseDescriptionEvent, CourseDescriptionState> {
  CourseDescriptionBloc() : super(CourseDescriptionState());

  Stream<CourseDescriptionState> mapEventToState(
      CourseDescriptionEvent event) async* {
    if (event is FetchCourseDetails) {
      yield* _mapFetchCourseDetailsToState(event);
    } else if (event is FetchUserById) {
      yield* _mapFetchUserByIdToState(event);
    } else if (event is FetchMaterialCountByCourseId) {
      yield* _mapFetchMaterialCountByCourseIdToState(event);
    } else if (event is FetchStudentCountByCourseId) {
      yield* _mapFetchStudentCountByCourseIdToState(event);
    } else if (event is GetMaterialByCourseId) {
      yield* _mapGetMaterialByCourseIdToState(event);
    }
  }

  Stream<CourseDescriptionState> _mapFetchCourseDetailsToState(
      FetchCourseDetails event) async* {
    try {
      final details =
          await CourseService.instance.fetchCourseById(event.courseId);
      yield state.copyWith(
        courseDetails: details,
        isLoading: false,
      );
    } catch (e) {
      print('Error fetching course details: $e');
      yield state.copyWith(isLoading: false);
    }
  }

  Stream<CourseDescriptionState> _mapFetchUserByIdToState(
      FetchUserById event) async* {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user_id = prefs.getInt('user_id');
      final accessToken = prefs.getString('access_token');

      if (user_id != null && accessToken != null) {
        final response = await EnrollService.instance
            .fetchEnrollmentbyUserIdnCourseId(
                user_id, event.courseId, accessToken);
        yield state.copyWith(
          active: response['active'],
          pending: response['pending'],
          progress: response['progress'],
        );
      } else {
        print('User ID or Access Token not found in SharedPreferences');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Stream<CourseDescriptionState> _mapFetchMaterialCountByCourseIdToState(
      FetchMaterialCountByCourseId event) async* {
    try {
      final response = await CountService.instance
          .getMaterialCountByCourseId(event.courseId);
      yield state.copyWith(materialCount: response);
    } catch (e) {
      print('Error fetching material count: $e');
    }
  }

  Stream<CourseDescriptionState> _mapFetchStudentCountByCourseIdToState(
      FetchStudentCountByCourseId event) async* {
    try {
      final response =
          await CountService.instance.getStudentCountByCourseId(event.courseId);
      yield state.copyWith(subCount: response);
    } catch (e) {
      print('Error fetching student count: $e');
    }
  }

  Stream<CourseDescriptionState> _mapGetMaterialByCourseIdToState(
      GetMaterialByCourseId event) async* {
    try {
      final addedMaterialData =
          await MaterialService.instance.getMaterialByCourseId(event.courseId);
      yield state.copyWith(addedMaterials: addedMaterialData);
    } catch (e) {
      print('Error fetching materials: $e');
    }
  }
}
