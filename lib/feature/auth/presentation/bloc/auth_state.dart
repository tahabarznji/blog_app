part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthFailure extends AuthState {
  final String massge;

  AuthFailure({required this.massge});
}

final class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess({required this.user});
}
