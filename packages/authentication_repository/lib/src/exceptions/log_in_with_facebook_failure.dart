class LogInWithFacebookFailure implements Exception {
  const LogInWithFacebookFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory LogInWithFacebookFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const LogInWithFacebookFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const LogInWithFacebookFailure(
          'Niepoprawne dane logowania',
        );
      case 'operation-not-allowed':
        return const LogInWithFacebookFailure(
          'Operacja niedozwolona. Proszę skontaktoawć się z supportem',
        );
      case 'user-disabled':
        return const LogInWithFacebookFailure(
          'Uzytkownik wylączony.',
        );
      case 'user-not-found':
        return const LogInWithFacebookFailure(
          'Użytkownika nie znaleziony.',
        );
      case 'wrong-password':
        return const LogInWithFacebookFailure(
          'Nieporawne haslo. Spróbuj jeszcze raz.',
        );
      case 'invalid-verification-code':
        return const LogInWithFacebookFailure(
          'Niepoprawny kod weryfikacji. Skontaktuj się z supportem.',
        );
      case 'invalid-verification-id':
        return const LogInWithFacebookFailure(
          'Niepoprawne id weryfikacji. Skontaktuj się z supportem.',
        );
      default:
        return const LogInWithFacebookFailure();
    }
  }

  final String message;
}
