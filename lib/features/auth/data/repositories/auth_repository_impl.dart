import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/remote_data_source.dart';
import '../models/user_model.dart';

typedef Future<UserModel> _GetUserModel();

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    this.remoteDataSource,
    this.networkInfo,
  });
  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await remoteDataSource.logout();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on LogoutException {
      return Left(LogoutFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
      {String email, String password}) async {
    return _auth(
      () => remoteDataSource.signInWitEmailandPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword(
      {String email, String password}) async {
    return _auth(
      () => remoteDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _auth(_GetUserModel getUserModel) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await getUserModel();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on SignUpException {
        return Left(SignUpFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
