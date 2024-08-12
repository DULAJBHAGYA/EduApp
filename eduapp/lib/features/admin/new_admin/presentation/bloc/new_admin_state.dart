import 'package:equatable/equatable.dart';

abstract class NewAdminState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NewAdminInitial extends NewAdminState {}

class NewAdminLoading extends NewAdminState {}

class NewAdminSuccess extends NewAdminState {}

class NewAdminError extends NewAdminState {
  final String userId;

  NewAdminError(this.userId);
  @override
  List<Object?> get props => [userId];
}
