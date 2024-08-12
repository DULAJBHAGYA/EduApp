import 'package:equatable/equatable.dart';

abstract class AddMaterialsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddMaterialsInitial extends AddMaterialsState {}

class AddMaterialsLoading extends AddMaterialsState {}

class AddMaterialsLoaded extends AddMaterialsState {
  final List<dynamic> addedMaterials;

  AddMaterialsLoaded({required this.addedMaterials});

  @override
  List<Object?> get props => [addedMaterials];
}

class AddMaterialsError extends AddMaterialsState {
  final String message;

  AddMaterialsError(this.message);

  @override
  List<Object?> get props => [message];
}
