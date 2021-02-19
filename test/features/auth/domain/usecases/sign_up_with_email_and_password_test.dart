import 'package:dartz/dartz.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/domain/entities/user.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/domain/usecases/sign_up_with_email_and_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  SignUpWithEmailAndPassword usecase;

  MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usecase = SignUpWithEmailAndPassword(repository: repository);
  });

  group('SignUpWithEmailUseCase', () {
    final tUser = User(
      email: 'test@mail',
      id: '1',
    );

    final tPassword = '123';
    test('should call sign up from auth repository', () {
      // arrange
      when(
        repository.signUpWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => Right(tUser));

      // act
      usecase(email: tUser.email, password: tPassword);

      //assert
      verify(
        repository.signUpWithEmailAndPassword(
            email: tUser.email, password: tPassword),
      );
    });

    test(
      'should return user from auth repository in success case',
      () async {
        // arrange
        when(
          repository.signUpWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => Right(tUser));

        // act
        final result = await usecase(email: tUser.email, password: tPassword);

        //assert
        expect(result, equals(Right(tUser)));
      },
    );
  });
}
