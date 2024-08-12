import 'package:eduapp/features/admin/add_material/data/dataSources/material_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_materials_event.dart';
import 'add_materials_state.dart';

class AddMaterialsBloc extends Bloc<AddMaterialsEvent, AddMaterialsState> {
  AddMaterialsBloc() : super(AddMaterialsInitial()) {
    on<FetchMaterialsByCourseId>(_onFetchMaterialsByCourseId);
  }

  Future<void> _onFetchMaterialsByCourseId(
    FetchMaterialsByCourseId event,
    Emitter<AddMaterialsState> emit,
  ) async {
    emit(AddMaterialsLoading());
    try {
      final addedMaterialData =
          await MaterialService.instance.getMaterialByCourseId(event.course_id);
      emit(AddMaterialsLoaded(addedMaterials: addedMaterialData ?? []));
    } catch (e) {
      emit(AddMaterialsError('Error fetching materials: $e'));
    }
  }
}
