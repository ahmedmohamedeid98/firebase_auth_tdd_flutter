part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticatedWithEmail extends AuthenticationEvent {
  final String email;
  final String password;

  AuthenticatedWithEmail({
    this.email,
    this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class CreateAccountWithEmail extends AuthenticationEvent {
  final String email;
  final String password;

  CreateAccountWithEmail({
    this.email,
    this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class Logout extends AuthenticationEvent {}

class NavigateToLogin extends AuthenticationEvent {}

class NavigateToSignUp extends AuthenticationEvent {}
