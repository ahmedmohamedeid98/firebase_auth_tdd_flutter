import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmailAndPassword {
  final AuthRepository repository;

  SignUpWithEmailAndPassword({
    this.repository,
  });

  Future<Either<Failure, User>> call({String email, String password}) {
    return repository.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
