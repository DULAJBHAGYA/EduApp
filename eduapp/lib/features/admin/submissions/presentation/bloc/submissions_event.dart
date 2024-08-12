import 'package:equatable/equatable.dart';

abstract class SubmissionsEvent extends Equatable {
  const SubmissionsEvent();

  @override
  List<Object> get props => [];
}

class FetchSubmissions extends SubmissionsEvent {}
