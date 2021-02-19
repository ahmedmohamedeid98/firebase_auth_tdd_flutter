part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Welcome extends AuthenticationState {}

class Loading extends AuthenticationState {}

class Error extends AuthenticationState {
  final String message;

  Error({this.message});
}

class Authenticated extends AuthenticationState {
  final User user;

  Authenticated({this.user});

  @override
  List<Object> get props => [user];
}

class Unauthenticated extends AuthenticationState {}

class NewAccount extends AuthenticationState {}
