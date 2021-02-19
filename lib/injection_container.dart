import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth_tdd_flutter/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:get_it/get_it.dart';

import 'core/network/network_info.dart';
import 'features/auth/data/datasource/remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/sign_up_with_email_and_password.dart';
import 'features/auth/presentation/bloc/authentication_bloc.dart';

final sl = GetIt.instance;

init() {
  //! Features
  // Bloc
  sl.registerFactory(
    () => AuthenticationBloc(
      signUpWithEmail: sl(),
      signInWithEmail: sl(),
      logout: sl(),
    ),
  );

  // Usecases
  sl.registerLazySingleton(
    () => SignInWithEmailAndPassword(repository: sl()),
  );
  sl.registerLazySingleton(
    () => SignUpWithEmailAndPassword(repository: sl()),
  );
  sl.registerLazySingleton(
    () => LogoutUser(repository: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Datasource
  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDatasourceImpl(),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  //! External
  sl.registerLazySingleton(() => DataConnectionChecker());
}
