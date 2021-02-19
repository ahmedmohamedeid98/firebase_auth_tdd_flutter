class SignUpException implements Exception {}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class SignInException implements Exception {}

class LogoutException implements Exception {}
