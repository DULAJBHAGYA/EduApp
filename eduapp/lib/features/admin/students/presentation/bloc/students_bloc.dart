import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'students_event.dart';
part 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  StudentsBloc() : super(StudentsInitial()) {
    on<StudentsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}