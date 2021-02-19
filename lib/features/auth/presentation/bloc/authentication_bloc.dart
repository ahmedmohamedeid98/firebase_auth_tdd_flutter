import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/sign_in_with_email_and_password.dart';
import '../../domain/usecases/sign_up_with_email_and_password.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

const String SIGNUP_FAILURE_MESSAGE = 'SignIn Failure message';
const String SIGNIN_FAILURE_MESSAGE = 'SignUp Failure message';
const String LOGOUT_FAILURE_MESSAGE = 'Logout Failure message';
const String CONNECTION_FAILURE_MESSAGE = 'Check your internet Connection.';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SignInWithEmailAndPassword signInWithEmail;
  final SignUpWithEmailAndPassword signUpWithEmail;
  final LogoutUser logout;

  AuthenticationBloc({
    @required this.signInWithEmail,
    @required this.signUpWithEmail,
    @required this.logout,
  })  : assert(signInWithEmail != null),
        assert(signUpWithEmail != null),
        assert(logout != null),
        super(Welcome());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticatedWithEmail) {
      yield Loading();
      final result = await signInWithEmail(
        email: event.email,
        password: event.password,
      );
      yield* _authenticateUser(result);
    } else if (event is CreateAccountWithEmail) {
      yield Loading();
      final result = await signUpWithEmail(
        email: event.email,
        password: event.password,
      );
      yield* _authenticateUser(result);
    } else if (event is Logout) {
      Loading();
      final result = await logout();
      yield* result.fold(
        (failure) async* {
          yield Error(message: _mapFailureToString(failure));
        },
        (_) async* {
          yield Welcome();
        },
      );
    } else if (event is NavigateToLogin) {
      yield Unauthenticated();
    } else if (event is NavigateToSignUp) {
      yield NewAccount();
    } else {
      Error(message: 'Error State');
    }
  }

  Stream<AuthenticationState> _authenticateUser(
      Either<Failure, User> result) async* {
    yield* result.fold(
      (failure) async* {
        yield Error(message: _mapFailureToString(failure));
      },
      (user) async* {
        yield Authenticated(user: user);
      },
    );
  }

  String _mapFailureToString(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case SignInFailure:
        return SIGNIN_FAILURE_MESSAGE;
      case SignUpFailure:
        return SIGNUP_FAILURE_MESSAGE;
      case LogoutFailure:
        return LOGOUT_FAILURE_MESSAGE;
      case ConnectionFailure:
        return CONNECTION_FAILURE_MESSAGE;

      default:
        return 'Unexpected Error';
    }
  }
}
