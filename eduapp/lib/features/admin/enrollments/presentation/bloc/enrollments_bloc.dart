import 'package:bloc/bloc.dart';
import 'enrollments_event.dart';
import 'enrollments_state.dart';
import 'package:eduapp/features/admin/enrollments/data/dataSources/enroll_service.dart';

class EnrollmentsBloc extends Bloc<EnrollmentsEvent, EnrollmentsState> {
  EnrollmentsBloc() : super(EnrollmentsInitial()) {
    on<FetchEnrollments>(_onFetchEnrollments);
    on<AcceptEnrollRequest>(_onAcceptEnrollRequest);
    on<DeclineEnrollRequest>(_onDeclineEnrollRequest);
  }

  void _onFetchEnrollments(
      FetchEnrollments event, Emitter<EnrollmentsState> emit) async {
    emit(EnrollmentsLoading());
    try {
      final enrollData = await EnrollService.instance.fetchAllEnrollments();
      final pendingEnrollments = enrollData
          .where((enrollment) => enrollment['pending'] == true)
          .toList();
      emit(EnrollmentsLoaded(pendingEnrollments));
    } catch (e) {
      emit(EnrollmentsError('Error fetching enrollments: $e'));
    }
  }

  void _onAcceptEnrollRequest(
      AcceptEnrollRequest event, Emitter<EnrollmentsState> emit) async {
    try {
      await EnrollService.instance.editEnrollment(
        user_id: event.userId,
        active: true,
        pending: false,
        course_id: event.courseId,
      );
      emit(EnrollmentActionSuccess('Enrollment request accepted'));
      add(FetchEnrollments()); // Refetch enrollments
    } catch (e) {
      emit(EnrollmentsError('Failed to accept request: $e'));
    }
  }

  void _onDeclineEnrollRequest(
      DeclineEnrollRequest event, Emitter<EnrollmentsState> emit) async {
    try {
      await EnrollService.instance.deleteSubscriptionRequest(event.userId);
      emit(EnrollmentActionSuccess('Enrollment request declined'));
      add(FetchEnrollments()); // Refetch enrollments
    } catch (e) {
      emit(EnrollmentsError('Failed to decline request: $e'));
    }
  }
}
