class UpdateUserCredentialsFailure implements Exception {
  const UpdateUserCredentialsFailure([
    this.message = 'Wystąpil nieznany bląd, skontaktuj się z supportem.',
  ]);

  final String message;
}
