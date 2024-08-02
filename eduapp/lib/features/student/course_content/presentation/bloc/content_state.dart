part of 'content_bloc.dart';

sealed class ContentState extends Equatable {
  const ContentState();
  
  @override
  List<Object> get props => [];
}

final class ContentInitial extends ContentState {}
