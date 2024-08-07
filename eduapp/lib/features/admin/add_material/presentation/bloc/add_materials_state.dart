part of 'add_materials_bloc.dart';

sealed class AddMaterialsState extends Equatable {
  const AddMaterialsState();
  
  @override
  List<Object> get props => [];
}

final class AddMaterialsInitial extends AddMaterialsState {}
