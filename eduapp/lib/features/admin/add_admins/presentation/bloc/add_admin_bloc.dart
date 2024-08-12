import 'package:eduapp/features/admin/add_admins/data/dataSources/admin_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_admin_event.dart';
import 'add_admin_state.dart';

class AddAdminBloc extends Bloc<AddAdminEvent, AddAdminState> {
  AddAdminBloc() : super(AdminsInitial()) {
    on<FetchAdmins>(_onFetchAdmins);
    on<AddNewAdmin>(_onAddNewAdmin);
  }

  Future<void> _onFetchAdmins(
      FetchAdmins event, Emitter<AddAdminState> emit) async {
    emit(AdminsLoading());
    try {
      final admins = await AdminService.instance.fetchAllAdmins();
      emit(AdminsLoaded(admins));
    } catch (e) {
      emit(AdminsError('Failed to fetch admins: $e'));
    }
  }

  Future<void> _onAddNewAdmin(
      AddNewAdmin event, Emitter<AddAdminState> emit) async {
    emit(AdminsLoading());
    try {
      await AdminService.instance.postAdmin(
        event.userName,
        event.firstName,
        event.lastName,
        event.email,
        event.password,
        event.role,
      );
      add(FetchAdmins()); // Fetch admins again after adding a new one
    } catch (e) {
      emit(AdminsError('Failed to add new admin: $e'));
    }
  }
}
