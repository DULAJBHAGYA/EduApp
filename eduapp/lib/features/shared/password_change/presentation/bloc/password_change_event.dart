import 'package:equatable/equatable.dart';

abstract class PasswordChangeEvent extends Equatable {
  const PasswordChangeEvent();

  @override
  List<Object?> get props => [];
}

class SubmitPasswordChange extends PasswordChangeEvent {
  final int userId;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const SubmitPasswordChange({
    required this.userId,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props =>
      [userId, currentPassword, newPassword, confirmPassword];
}
