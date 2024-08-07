import 'package:bloc/bloc.dart';
import 'package:eduapp/features/admin/add_courses/data/dataSources/course_service.dart';
import 'package:eduapp/features/admin/add_courses/presentation/bloc/add_courses_event.dart';
import 'package:eduapp/features/admin/add_courses/presentation/bloc/add_courses_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCoursesBloc extends Bloc<AddCoursesEvent, AddCoursesState> {
  AddCoursesBloc() : super(AddCoursesInitial()) {
    on<FetchCoursesById>(_onFetchCoursesById);
  }

  Future<void> _onFetchCoursesById(
    FetchCoursesById event,
    Emitter<AddCoursesState> emit,
  ) async {
    emit(AddCoursesLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('user_id');

      if (userId == null) {
        throw Exception('User ID not found in local storage');
      }

      final addedCourseData =
          await CourseService.instance.getCourseByUserId(userId);

      emit(AddCoursesLoaded(addedCourses: addedCourseData ?? []));
    } catch (e) {
      emit(AddCoursesError('Error fetching courses: $e'));
    }
  }
}
