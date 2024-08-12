import 'package:equatable/equatable.dart';

abstract class AddAdminState extends Equatable {
  const AddAdminState();

  @override
  List<Object> get props => [];
}

class AdminsInitial extends AddAdminState {}

class AdminsLoading extends AddAdminState {}

class AdminsLoaded extends AddAdminState {
  final List<dynamic> admins;

  const AdminsLoaded(this.admins);

  @override
  List<Object> get props => [admins];
}

class AdminsError extends AddAdminState {
  final String message;

  const AdminsError(this.message);

  @override
  List<Object> get props => [message];
}
