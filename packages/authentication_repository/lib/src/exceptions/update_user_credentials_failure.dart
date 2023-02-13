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
      case 'user-disabled':
        return const UpdateUserCredentialsFailure(
          'Uźytkownik zostal wylączony. Skontaktuj się z supportem aby uzyskać pomoc',
        );
      case 'email-already-in-use':
        return const UpdateUserCredentialsFailure(
          'Konto z tym adresem e-mail już istnije.',
        );
      case 'operation-not-allowed':
        return const UpdateUserCredentialsFailure(
          'Operacja nie jest dozwolona. Proszę, skontaktuj się z supportem',
        );
      case 'weak-password':
        return const UpdateUserCredentialsFailure(
          'Za slabe haslo, pomyśl nad bardziej skomplikowanym haslem',
        );
      default:
        return const UpdateUserCredentialsFailure();
    }
  }

  final String message;
}
