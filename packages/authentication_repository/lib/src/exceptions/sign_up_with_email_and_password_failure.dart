class SignUpWithEmailAndPasswordFailure implements Exception {
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'Wystąpil nieznany bląd, skontaktuj się z supportem.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'Niepoprawny e-mail. Sprawdź poprawność maila.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'Uźytkownik zostal wylączony. Skontaktuj się z supportem aby uzyskać pomoc',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'Konto z tym adresem e-mail już istnije.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'Operacja nie jest dozwolona. Proszę, skontaktuj się z supportem',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'Za slabe haslo, pomyśl nad bardziej skomplikowanym haslem',
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }

  final String message;
}