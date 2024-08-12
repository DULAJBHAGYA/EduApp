import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduapp/features/admin/course_delete_requests/data/dataSources/admin_requests_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'delete_requests_event.dart';
import 'delete_requests_state.dart';

class DeleteRequestsBloc
    extends Bloc<DeleteRequestsEvent, DeleteRequestsState> {
  DeleteRequestsBloc() : super(DeleteRequestsInitial()) {
    on<FetchDeleteRequests>(_onFetchDeleteRequests);
    on<ConfirmDeleteRequest>(_onConfirmDeleteRequest);
  }

  Future<void> _onFetchDeleteRequests(
      FetchDeleteRequests event, Emitter<DeleteRequestsState> emit) async {
    emit(DeleteRequestsLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? user_id = prefs.getInt('user_id');

      if (user_id != null) {
        final delRequestData =
            await AdminRequestsService.instance.fetchAllAdminRequests(user_id);
        emit(DeleteRequestsLoaded(delRequestData ?? []));
      } else {
        emit(const DeleteRequestsError('Error: user_id is null'));
      }
    } catch (e) {
      emit(DeleteRequestsError('Error fetching delete requests: $e'));
    }
  }

  Future<void> _onConfirmDeleteRequest(
      ConfirmDeleteRequest event, Emitter<DeleteRequestsState> emit) async {
    final currentState = state;
    if (currentState is DeleteRequestsLoaded) {
      // Simulate removal of the request after confirmation
      final updatedRequests = currentState.deleteRequests
          .where((request) => request['request_id'] != event.requestId)
          .toList();
      emit(DeleteRequestsLoaded(updatedRequests));
    }
  }
}
