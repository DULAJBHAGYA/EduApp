import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eduapp/features/shared/auth/data/dataSources/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final userData =
          await UserService.instance.loginUser(event.username, event.password);

      final Map<String, dynamic> decodedToken =
          parseJwt(userData['access_token']);

      final String accessToken = userData['access_token'];

      await saveUserData(event.username, decodedToken['role'],
          decodedToken['user_id'], accessToken, userData['refresh_token']);

      if (decodedToken['role'] == 'admin') {
        emit(AuthAdminSuccess(
          username: event.username,
          accessToken: accessToken,
          refreshToken: userData['refresh_token'],
        ));
      } else {
        emit(AuthStudentSuccess(
          username: event.username,
          accessToken: accessToken,
          refreshToken: userData['refresh_token'],
        ));
      }
    } catch (e) {
      emit(AuthFailure(error: 'Invalid username or password.'));
    }
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = parts[1];
    final String normalized = base64Url.normalize(payload);
    final String decoded = utf8.decode(base64Url.decode(normalized));

    return json.decode(decoded);
  }

  Future<void> saveUserData(String username, String role, int userId,
      String accessToken, String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('role', role);
    await prefs.setInt('user_id', userId);

    await saveToken(accessToken, refreshToken);
  }

  Future<void> saveToken(String accessToken, String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }
}
