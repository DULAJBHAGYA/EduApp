import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_course_event.dart';
part 'edit_course_state.dart';

class EditCourseBloc extends Bloc<EditCourseEvent, EditCourseState> {
  EditCourseBloc() : super(EditCourseInitial()) {
    on<EditCourseEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
