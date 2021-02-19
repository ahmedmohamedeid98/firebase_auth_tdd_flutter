import 'package:dartz/dartz.dart';
import 'package:firebase_auth_tdd_flutter/core/errors/failure.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/cupertino.dart';

class LogoutUser {
  final AuthRepository repository;

  LogoutUser({@required this.repository});

  Future<Either<Failure, bool>> call() {
    return repository.logout();
  }
}
