import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List<dynamic> properties = const <dynamic>[];
  Failure([properties]);

  @override
  List<Object> get props => [properties];
}

class SignUpFailure extends Failure {}

class SignInFailure extends Failure {}

class ConnectionFailure extends Failure {}

class LogoutFailure extends Failure {}

class ServerFailure extends Failure {
  final String message;
  ServerFailure(this.message) : super(message);
}
