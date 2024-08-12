import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'new_materials_event.dart';
part 'new_materials_state.dart';

class NewMaterialsBloc extends Bloc<NewMaterialsEvent, NewMaterialsState> {
  NewMaterialsBloc() : super(NewMaterialsInitial()) {
    on<NewMaterialsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
