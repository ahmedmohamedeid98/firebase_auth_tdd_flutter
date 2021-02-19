// Dependancies
import 'package:dartz/dartz.dart';
import 'package:firebase_auth_tdd_flutter/core/errors/failure.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/domain/entities/user.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/domain/usecases/logout.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/domain/usecases/sign_up_with_email_and_password.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockSignInWithEmailAndPassword extends Mock
    implements SignInWithEmailAndPassword {}

class MockSignUpWithEmailAndPassword extends Mock
    implements SignUpWithEmailAndPassword {}

class MockLogoutUser extends Mock implements LogoutUser {}

void main() {
  AuthenticationBloc bloc;
  MockSignInWithEmailAndPassword mockSignInWithEmail;
  MockSignUpWithEmailAndPassword mockSignUpWithEmail;
  MockLogoutUser mockLogoutUser;

  setUp(() {
    mockSignUpWithEmail = MockSignUpWithEmailAndPassword();
    mockSignInWithEmail = MockSignInWithEmailAndPassword();
    mockLogoutUser = MockLogoutUser();

    bloc = AuthenticationBloc(
      signInWithEmail: mockSignInWithEmail,
      signUpWithEmail: mockSignUpWithEmail,
      logout: mockLogoutUser,
    );
  });

  tearDown(() {
    bloc = null;
    mockSignInWithEmail = null;
    mockSignUpWithEmail = null;
  });

  test('Init State should be Welcome', () {
    // assert
    expect(bloc.state, equals(Welcome()));
  });

  group('CreateAccountWithEmail : ', () {
    final tUser = User(email: 'test', id: '123');
    final tEmail = 'test';
    final tPassword = 'pass';
    test('should call Authenticate with email event', () async {
      // arrange
      when(
        mockSignUpWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => Right(tUser));

      // act
      bloc.add(CreateAccountWithEmail(email: tEmail, password: tPassword));
      await untilCalled(
          mockSignUpWithEmail(email: tEmail, password: tPassword));
      // assert
      //* ensure that usecase was fired in the bloc */
      verify(mockSignUpWithEmail(email: tEmail, password: tPassword));
    });

    test('should Emit [Loading, Authenticated] when sign up successfully.',
        () async {
      // arrange
      when(
        mockSignUpWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => Right(tUser));

      final expectedStates = [
        Loading(),
        Authenticated(user: tUser),
      ];

      // assert Later
      expectLater(bloc, emitsInOrder(expectedStates));

      // act
      bloc.add(CreateAccountWithEmail(email: tEmail, password: tPassword));
    });

    test('should Emit [Loading, Error] when sign up failure.', () async {
      // arrange
      when(
        mockSignUpWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => Left(ServerFailure('weak password')));

      final expectedStates = [
        Loading(),
        Error(),
      ];

      // assert Later
      expectLater(bloc, emitsInOrder(expectedStates));

      // act
      bloc.add(CreateAccountWithEmail(email: tEmail, password: tPassword));
    });
  });

  group('LoginWithEmail : ', () {
    final tUser = User(email: 'test', id: '123');
    final tEmail = 'test';
    final tPassword = 'pass';
    test('should call unAuthenticated with email event', () async {
      // arrange
      when(
        mockSignInWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => Right(tUser));

      // act
      bloc.add(AuthenticatedWithEmail(email: tEmail, password: tPassword));
      await untilCalled(
          mockSignInWithEmail(email: tEmail, password: tPassword));
      // assert
      //* ensure that usecase was fired in the bloc */
      verify(mockSignInWithEmail(email: tEmail, password: tPassword));
    });

    test('should Emit [Loading, Authenticated] when sign up successfully.',
        () async {
      // arrange
      when(
        mockSignInWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => Right(tUser));

      final expectedStates = [
        Loading(),
        Authenticated(user: tUser),
      ];

      // assert Later
      expectLater(bloc, emitsInOrder(expectedStates));

      // act
      bloc.add(AuthenticatedWithEmail(email: tEmail, password: tPassword));
    });

    test('should Emit [Loading, Error] when sign up failure.', () async {
      // arrange
      when(
        mockSignInWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => Left(ServerFailure('weak password')));

      final expectedStates = [
        Loading(),
        Error(),
      ];

      // assert Later
      expectLater(bloc, emitsInOrder(expectedStates));

      // act
      bloc.add(AuthenticatedWithEmail(email: tEmail, password: tPassword));
    });
  });
}
