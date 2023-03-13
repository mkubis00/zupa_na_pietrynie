class SignUpString {
  static const String SIGN_UP_BUTTON = 'Zarejestruj się';
  static const String CONFIRM_PASSWORD_INPUT_LABEL = 'powtórz hasło';
  static const String PASSWORD_DO_NOT_MATCH = 'hasła nie są identyczne';
  static const String PASSWORD_INPUT_LABEL = 'hasło';
  static const String PASSWORD_INPUT_INVALID = 'niepoprawne hasło';
  static const String EMAIN_INPUT_LABEL = 'e-mail';
  static const String EMAIL_INPUT_INVALID = 'niepoprawny e-mail';
  static const String SNACK_BAR_ACCOUNT_NOT_CREATED =
      'Nie udało się stworzyć konta.';
  static const String MAIN_INSCRIPTION = 'Nie masz jeszcze konta?';
  static const String SECOND_INSCRIPTION = 'Zarejestruj aby kontynuować';

  static String snackBarAccountCreated(String email) {
    return 'Stworzono konto, aby się zalogować zweryfikuj swój e-mail wyslany na adres $email';
  }
}
