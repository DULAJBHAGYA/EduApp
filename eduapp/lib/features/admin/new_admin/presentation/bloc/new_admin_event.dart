import 'package:equatable/equatable.dart';

abstract class NewAdminEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitNewAdmin extends NewAdminEvent {
  final String firstname;
  final String lastname;
  final String email;
  final String username;
  final String password;
  final String role;

  SubmitNewAdmin({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.username,
    required this.password,
    required this.role,
  });
  @override
  List<Object?> get props => [
        firstname,
        lastname,
        email,
        username,
        password,
        role,
      ];
}
