import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'submissions_event.dart';
import 'submissions_state.dart';
import 'package:eduapp/features/admin/submissions/data/dataSources/submission_service.dart';

class SubmissionsBloc extends Bloc<SubmissionsEvent, SubmissionsState> {
  SubmissionsBloc() : super(SubmissionsInitial()) {
    on<FetchSubmissions>(_onFetchSubmissions);
  }

  Future<void> _onFetchSubmissions(
      FetchSubmissions event, Emitter<SubmissionsState> emit) async {
    emit(SubmissionsLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('user_id');

      if (userId != null) {
        final submissionData =
            await SubmissionService.instance.getSubmissionsByAdminId(userId);
        emit(SubmissionsLoaded(submissionData ?? []));
      } else {
        emit(const SubmissionsError('Error: User ID is null'));
      }
    } catch (e) {
      emit(SubmissionsError('Error fetching submissions: $e'));
    }
  }
}
