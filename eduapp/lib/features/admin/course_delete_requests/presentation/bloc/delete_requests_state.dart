import 'package:equatable/equatable.dart';

abstract class DeleteRequestsState extends Equatable {
  const DeleteRequestsState();

  @override
  List<Object> get props => [];
}

class DeleteRequestsInitial extends DeleteRequestsState {}

class DeleteRequestsLoading extends DeleteRequestsState {}

class DeleteRequestsLoaded extends DeleteRequestsState {
  final List<dynamic> deleteRequests;

  const DeleteRequestsLoaded(this.deleteRequests);

  @override
  List<Object> get props => [deleteRequests];
}

class DeleteRequestsError extends DeleteRequestsState {
  final String message;

  const DeleteRequestsError(this.message);

  @override
  List<Object> get props => [message];
}
