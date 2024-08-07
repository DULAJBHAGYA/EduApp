import 'package:equatable/equatable.dart';

abstract class AdminProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAdminById extends AdminProfileEvent {}
