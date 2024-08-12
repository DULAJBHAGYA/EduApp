import 'package:equatable/equatable.dart';

abstract class AddAdminEvent extends Equatable {
  const AddAdminEvent();

  @override
  List<Object?> get props => [];
}

class FetchAdmins extends AddAdminEvent {}

class AddNewAdmin extends AddAdminEvent {
  final String userName;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String role;

  const AddNewAdmin({
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props =>
      [userName, firstName, lastName, email, password, role];
}
