import 'package:dartz/dartz.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/domain/entities/user.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  SignInWithEmailAndPassword usecase;
  MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usecase = SignInWithEmailAndPassword(repository: repository);
  });

  final tUser = User(
    email: 'test@mail',
    id: '1',
  );

  final tPassword = '123';

  test('should call SignIn Method from auth repository', () {
    //* arrange
    when(
      repository.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenAnswer((_) async => Right(tUser));
    // act
    usecase(email: tUser.email, password: tPassword);

    //! assert
    verify(
      repository.signInWithEmailAndPassword(
        email: tUser.email,
        password: tPassword,
      ),
    );
  });
}
