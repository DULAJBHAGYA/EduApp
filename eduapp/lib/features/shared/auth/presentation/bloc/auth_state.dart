part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAdminSuccess extends AuthState {
  final String username;
  final String accessToken;
  final String refreshToken;

  const AuthAdminSuccess({
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object> get props => [username, accessToken, refreshToken];
}

class AuthStudentSuccess extends AuthState {
  final String username;
  final String accessToken;
  final String refreshToken;

  const AuthStudentSuccess({
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object> get props => [username, accessToken, refreshToken];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}
