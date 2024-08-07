import 'package:bloc/bloc.dart';
import 'package:eduapp/features/admin/admin_profile/presentation/bloc/admin_profile_event.dart';
import 'package:eduapp/features/admin/admin_profile/presentation/bloc/admin_profile_state.dart';
import 'package:eduapp/features/student/profile/data/dataSources/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProfileBloc extends Bloc<AdminProfileEvent, AdminProfileState> {
  AdminProfileBloc() : super(AdminProfileState()) {
    on<FetchAdminById>(_onFetchUserById);
  }

  Future<void> _onFetchUserById(
    FetchAdminById event,
    Emitter<AdminProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      final accessToken = prefs.getString('access_token');

      if (userId != null && accessToken != null) {
        final response =
            await UserService.instance.fetchUsersById(userId, accessToken);

        emit(state.copyWith(
          firstName: response['GetUserIDRow']['first_name'],
          lastName: response['GetUserIDRow']['last_name'],
          userName: response['GetUserIDRow']['user_name'],
          email: response['GetUserIDRow']['email'],
          picture: response['GetUserIDRow']['picture'],
          userId: userId,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          error: 'User ID or Access Token not found in SharedPreferences',
          isLoading: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        error: 'Error fetching user info: $e',
        isLoading: false,
      ));
    }
  }
}