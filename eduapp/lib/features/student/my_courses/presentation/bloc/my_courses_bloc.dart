// my_courses_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:eduapp/features/student/my_courses/data/dataSources/count_service.dart';
import 'package:eduapp/features/student/my_courses/presentation/bloc/my_courses_event.dart';
import 'package:eduapp/features/student/my_courses/presentation/bloc/my_courses_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCoursesBloc extends Bloc<MyCoursesEvent, MyCoursesState> {
  MyCoursesBloc() : super(MyCoursesInitial()) {
    on<FetchOngoingCourses>(_onFetchOngoingCourses);
    on<FetchCompletedCourses>(_onFetchCompletedCourses);
  }

  Future<void> _onFetchOngoingCourses(
      FetchOngoingCourses event, Emitter<MyCoursesState> emit) async {
    emit(MyCoursesLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        emit(MyCoursesError('User ID is null'));
        return;
      }

      final response =
          await CountService.instance.getOngoingCourseCountByUserId(userId);

      if (response is int) {
        emit(OngoingCoursesFetched(response));
      } else {
        emit(MyCoursesError('Invalid response type'));
      }
    } catch (e) {
      emit(MyCoursesError('Error fetching ongoing courses: $e'));
    }
  }

  Future<void> _onFetchCompletedCourses(
      FetchCompletedCourses event, Emitter<MyCoursesState> emit) async {
    emit(MyCoursesLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        emit(MyCoursesError('User ID is null'));
        return;
      }

      final response =
          await CountService.instance.getCompletedCourseCountByUserId(userId);

      if (response is int) {
        emit(CompletedCoursesFetched(response));
      } else {
        emit(MyCoursesError('Invalid response type'));
      }
    } catch (e) {
      emit(MyCoursesError('Error fetching completed courses: $e'));
    }
  }
}
