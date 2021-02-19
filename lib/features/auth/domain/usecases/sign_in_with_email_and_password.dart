import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmailAndPassword {
  final AuthRepository repository;

  SignInWithEmailAndPassword({@required this.repository});

  Future<Either<Failure, User>> call({
    String email,
    String password,
  }) {
    return repository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
