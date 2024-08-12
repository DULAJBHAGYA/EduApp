import 'package:bloc/bloc.dart';
import 'package:eduapp/features/admin/new_admin/data/dataSources/admin_service.dart';
import 'new_admin_event.dart';
import 'new_admin_state.dart';

class NewAdminBloc extends Bloc<NewAdminEvent, NewAdminState> {
  NewAdminBloc() : super(NewAdminInitial()) {
    on<SubmitNewAdmin>(
        mapEventToState as EventHandler<SubmitNewAdmin, NewAdminState>);
  }

  Stream<NewAdminState> mapEventToState(NewAdminEvent event) async* {
    if (event is SubmitNewAdmin) {
      yield NewAdminLoading();
      try {
        await AdminService.instance.postAdmin(
          event.role,
          event.email,
          event.firstname,
          event.lastname,
          event.password,
          event.username,
        );
        yield NewAdminSuccess();
      } catch (e) {
        yield NewAdminError('Failed to add new admin.');
      }
    }
  }
}
