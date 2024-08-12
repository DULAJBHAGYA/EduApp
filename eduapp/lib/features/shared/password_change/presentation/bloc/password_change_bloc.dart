import 'package:bloc/bloc.dart';
import 'package:eduapp/features/shared/password_change/data/dataSources/password_service.dart';
import 'password_change_event.dart';
import 'password_change_state.dart';

class PasswordChangeBloc
    extends Bloc<PasswordChangeEvent, PasswordChangeState> {
  PasswordChangeBloc() : super(PasswordChangeInitial()) {
    on<SubmitPasswordChange>(_onSubmitPasswordChange);
  }

  void _onSubmitPasswordChange(
    SubmitPasswordChange event,
    Emitter<PasswordChangeState> emit,
  ) async {
    emit(PasswordChangeLoading());
    try {
      final response = await Passwordservice.instance.editPassword(
        user_id: event.userId,
        current_password: event.currentPassword,
        hashed_password: event.newPassword,
        confirm_password: event.confirmPassword,
      );

      if (response != null && response['statusCode'] == 200) {
        emit(PasswordChangeSuccess());
      } else {
        emit(PasswordChangeFailure(error: 'Password change failed'));
      }
    } catch (e) {
      emit(PasswordChangeFailure(error: e.toString()));
    }
  }
}
