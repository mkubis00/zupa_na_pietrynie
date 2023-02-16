class LogInWithGoogleFailure implements Exception {
  const LogInWithGoogleFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory LogInWithGoogleFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const LogInWithGoogleFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const LogInWithGoogleFailure(
          'Blędne dane logowania.',
        );
      case 'operation-not-allowed':
        return const LogInWithGoogleFailure(
          'Operacja niedozwolona.',
        );
      case 'user-disabled':
        return const LogInWithGoogleFailure(
          'Użytkownik zostal wylączony.',
        );
      case 'user-not-found':
        return const LogInWithGoogleFailure(
          'Nie znaleziono użytkownika z podanym adresem e-mail.',
        );
      case 'wrong-password':
        return const LogInWithGoogleFailure(
          'Niepoprawne haslo.',
        );
      case 'invalid-verification-code':
        return const LogInWithGoogleFailure(
          'Niepoprawny kod weryfikacyjny.',
        );
      case 'invalid-verification-id':
        return const LogInWithGoogleFailure(
          'Niepoprawne ID weryfickacji.',
        );
      default:
        return const LogInWithGoogleFailure();
    }
  }

  final String message;
}