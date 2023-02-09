class PasswordResetFailure implements Exception {
  const PasswordResetFailure([
    this.message = 'Wystąpil nieznany bląd, skontaktuj się z supportem.',
  ]);

  factory PasswordResetFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const PasswordResetFailure(
          'Niepoprawny e-mail. Sprawdź poprawność maila.',
        );
      case 'user-not-found':
        return const PasswordResetFailure(
          'Nie znaleziono użytkownika z podanym adresem e-mail',
        );
      default:
        return const PasswordResetFailure();
    }
  }

  final String message;
}