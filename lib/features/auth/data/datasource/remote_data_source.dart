import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class RemoteDataSource {
  Future<UserModel> signInWitEmailandPassword({String email, String password});
  Future<UserModel> signUpWithEmailAndPassword({String email, String password});
  Future<bool> logout();
}

class RemoteDatasourceImpl implements RemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<UserModel> signInWitEmailandPassword(
      {String email, String password}) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel(email: result.user.email, id: result.user.uid);
    } on FirebaseException catch (exception) {
      throw ServerException(exception.message);
    } catch (_) {
      throw SignInException();
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
      {String email, String password}) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel(email: result.user.email, id: result.user.uid);
    } on FirebaseException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw SignUpException();
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _auth.signOut();
      return true;
    } on FirebaseException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw LogoutException();
    }
  }
}
