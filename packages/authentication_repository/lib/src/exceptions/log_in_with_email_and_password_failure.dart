class LogInWithEmailAndPasswordFailure implements Exception {
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'Niepoprawny e-mail',
        );
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
          'Uzytkownik zostal wylączony.',
        );
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
          'Nie znaleziono użytkownika z podanym adresem e-mail.',
        );
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
          'Nieporawne haslo.',
        );
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }

  final String message;
}