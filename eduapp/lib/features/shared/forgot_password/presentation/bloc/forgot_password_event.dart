import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class CheckEmailEvent extends ForgotPasswordEvent {
  final String email;

  const CheckEmailEvent(this.email);

  @override
  List<Object> get props => [email];
}

class ResetPasswordEvent extends ForgotPasswordEvent {
  final String email;
  final String password;
  final String confirmPassword;

  const ResetPasswordEvent({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [email, password, confirmPassword];
}
