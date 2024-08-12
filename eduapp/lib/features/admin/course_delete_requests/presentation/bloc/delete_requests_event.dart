import 'package:equatable/equatable.dart';

abstract class DeleteRequestsEvent extends Equatable {
  const DeleteRequestsEvent();

  @override
  List<Object> get props => [];
}

class FetchDeleteRequests extends DeleteRequestsEvent {}

class ConfirmDeleteRequest extends DeleteRequestsEvent {
  final int requestId;

  const ConfirmDeleteRequest(this.requestId);

  @override
  List<Object> get props => [requestId];
}
