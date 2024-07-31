import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String userName;
  final int userId;
  final String picture;
  final bool isLoading;
  final String error;

  const ProfileState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.userName = '',
    this.userId = 0,
    this.picture = '',
    this.isLoading = false,
    this.error = '',
  });

  ProfileState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? userName,
    int? userId,
    String? picture,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
      picture: picture ?? this.picture,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        userName,
        userId,
        picture,
        isLoading,
        error,
      ];
}
