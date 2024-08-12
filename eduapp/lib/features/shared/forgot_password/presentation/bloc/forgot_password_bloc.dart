import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduapp/features/shared/forgot_password/data/dataSources/email_service.dart';
import 'package:eduapp/features/shared/forgot_password/data/dataSources/password_service.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial());

  Stream<ForgotPasswordState> mapEventToState(
      ForgotPasswordEvent event) async* {
    if (event is CheckEmailEvent) {
      yield ForgotPasswordLoading();
      try {
        final response = await EmailService.instance.checkEmail(event.email);
        if (response != null) {
          yield ForgotPasswordSuccess();
        } else {
          yield ForgotPasswordFailure("Email check failed");
        }
      } catch (e) {
        yield ForgotPasswordFailure(e.toString());
      }
    } else if (event is ResetPasswordEvent) {
      yield ForgotPasswordLoading();
      try {
        final response = await Passwordservice.instance.resetPassword(
          email: event.email,
          hashed_password: event.password,
          confirm_password: event.confirmPassword,
        );

        if (response != null && response['statusCode'] == 200) {
          yield ForgotPasswordSuccess();
        } else {
          yield ForgotPasswordFailure("Password reset failed");
        }
      } catch (e) {
        yield ForgotPasswordFailure(e.toString());
      }
    }
  }
}
