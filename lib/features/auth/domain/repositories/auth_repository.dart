import 'package:dartz/dartz.dart';
import 'package:firebase_auth_tdd_flutter/core/errors/failure.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailAndPassword(
      {String email, String password});
  Future<Either<Failure, User>> signInWithEmailAndPassword(
      {String email, String password});
  Future<Either<Failure, bool>> logout();
}
