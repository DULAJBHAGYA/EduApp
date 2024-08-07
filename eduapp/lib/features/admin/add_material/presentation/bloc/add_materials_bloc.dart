import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_materials_event.dart';
part 'add_materials_state.dart';

class AddMaterialsBloc extends Bloc<AddMaterialsEvent, AddMaterialsState> {
  AddMaterialsBloc() : super(AddMaterialsInitial()) {
    on<AddMaterialsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
