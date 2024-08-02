part of 'students_bloc.dart';

sealed class StudentsState extends Equatable {
  const StudentsState();
  
  @override
  List<Object> get props => [];
}

final class StudentsInitial extends StudentsState {}
