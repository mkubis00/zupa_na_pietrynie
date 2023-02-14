class UpdateUserCredentialsFailure implements Exception {
  const UpdateUserCredentialsFailure([
    this.message = 'Wystąpil nieznany bląd, skontaktuj się z supportem.',
  ]);

  factory UpdateUserCredentialsFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const UpdateUserCredentialsFailure(
          'Niepoprawny e-mail. Sprawdź poprawność maila.',
        );
      case 'user-email-already-in-use':
        return const UpdateUserCredentialsFailure(
          'Ten mail jest już używany przrz innego użytkownika.',
        );
      case 'requires-recent-login':
        return const UpdateUserCredentialsFailure(
          'W celu zresetowania e-maila ponownie zaloguj się do aplikacji.',
        );
      default:
        return const UpdateUserCredentialsFailure();
    }
  }

  final String message;
}
