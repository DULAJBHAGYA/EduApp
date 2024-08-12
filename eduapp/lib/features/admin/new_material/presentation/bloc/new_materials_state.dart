part of 'new_materials_bloc.dart';

sealed class NewMaterialsState extends Equatable {
  const NewMaterialsState();
  
  @override
  List<Object> get props => [];
}

final class NewMaterialsInitial extends NewMaterialsState {}
