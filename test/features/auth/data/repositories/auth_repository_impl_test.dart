//! What it the dependancy ???
//* Remote Data Source
//* Network Info

import 'package:dartz/dartz.dart';
import 'package:firebase_auth_tdd_flutter/core/errors/exceptions.dart';
import 'package:firebase_auth_tdd_flutter/core/errors/failure.dart';
import 'package:firebase_auth_tdd_flutter/core/network/network_info.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/data/datasource/remote_data_source.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/data/models/user_model.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockRemoteDataSource remoteDataSource;
  MockNetworkInfo networkInfo;
  AuthRepositoryImpl repository;

  final tUserModel = UserModel(email: 'test@1', id: '123');
  final User tUser = tUserModel;
  final tPassword = '123';
  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  void runTestOnline(Function body) {
    group(
      '[Device Online] -> ',
      () {
        setUp(() {
          when(networkInfo.isConnected).thenAnswer((_) async => true);
        });
        body();
      },
    );
  }

  void runTestOffline(Function body) {
    group(
      '[Device Offline] -> ',
      () {
        setUp(() {
          when(networkInfo.isConnected).thenAnswer((_) async => false);
        });
        body();
      },
    );
  }

  //* Sign Up TEST
  group('Sign Up group: ', () {
    runTestOnline(() {
      test(
          'should return UserModel from auth repository when auth process done successfully',
          () async {
        when(
          remoteDataSource.signUpWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => tUserModel);
        // act
        final result = await repository.signUpWithEmailAndPassword(
            email: tUserModel.email, password: tPassword);
        // assert
        verify(networkInfo.isConnected);
        expect(result, Right(tUser));
      });

      test(
          'should return SignUpFailure from auth repository when auth process faild',
          () async {
        when(
          remoteDataSource.signUpWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(SignUpException());
        // act
        final result = await repository.signUpWithEmailAndPassword(
            email: tUserModel.email, password: tPassword);
        // assert
        verify(networkInfo.isConnected);
        expect(result, equals(Left(SignUpFailure())));
      });

      test(
          'should return FirebaseFailure from auth repository when Firebase exception throw',
          () async {
        when(
          remoteDataSource.signUpWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(ServerException('invalid name'));
        // act
        final result = await repository.signUpWithEmailAndPassword(
            email: tUserModel.email, password: tPassword);
        // assert
        verify(networkInfo.isConnected);
        expect(result, equals(Left((ServerFailure('invalid name')))));
      });
    });

    runTestOffline(() {
      test('should throw ConnectionFailure when the user is offline', () async {
        when(
          remoteDataSource.signUpWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => tUserModel);
        // act
        final result = await repository.signUpWithEmailAndPassword(
            email: tUserModel.email, password: tPassword);
        // assert
        expect(result, equals(Left(ConnectionFailure())));
      });
    });
  });

  group('Sign In group: ', () {
    runTestOnline(() {
      test(
          'should return UserModel from auth repository when sigin in process done successfully',
          () async {
        when(
          remoteDataSource.signInWitEmailandPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => tUserModel);
        // act
        final result = await repository.signInWithEmailAndPassword(
            email: tUserModel.email, password: tPassword);
        // assert
        verify(networkInfo.isConnected);
        expect(result, Right(tUser));
      });

      test(
          'should return SignUpFailure from auth repository when signin process faild',
          () async {
        when(
          remoteDataSource.signInWitEmailandPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(SignUpException());
        // act
        final result = await repository.signInWithEmailAndPassword(
            email: tUserModel.email, password: tPassword);
        // assert
        verify(networkInfo.isConnected);
        expect(result, equals(Left(SignUpFailure())));
      });

      test(
          'should return FirebaseFailure from auth repository when Firebase exception throw',
          () async {
        when(
          remoteDataSource.signInWitEmailandPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(ServerException('invalid name'));
        // act
        final result = await repository.signInWithEmailAndPassword(
            email: tUserModel.email, password: tPassword);
        // assert
        verify(networkInfo.isConnected);
        expect(result, equals(Left((ServerFailure('invalid name')))));
      });
    });

    runTestOffline(() {
      test('should throw ConnectionFailure when the user is offline', () async {
        when(
          remoteDataSource.signInWitEmailandPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => tUserModel);
        // act
        final result = await repository.signInWithEmailAndPassword(
            email: tUserModel.email, password: tPassword);
        // assert
        expect(result, equals(Left(ConnectionFailure())));
      });
    });
  });

  group('Logout group: ', () {
    runTestOnline(() async {
      test('Should Logout Successfully', () async {
        // act
        final result = await repository.logout();
        // assert
        expect(result, Right(null));
      });

      test(
          'Should return ServerFailure when firebase failed to logout the user',
          () async {
        // assert
        when(repository.logout()).thenThrow(
          ServerException('test message'),
        );
        // act
        final result = await repository.logout();
        // assert
        expect(result, Left(ServerFailure('test message')));
      });

      test('Should return LogoutFailure when something want wrong', () async {
        // arrange
        when(repository.logout()).thenThrow(
          LogoutException(),
        );

        // act
        final result = await repository.logout();
        // assert
        expect(result, Left(LogoutFailure()));
      });
    });
  });
}
