import 'package:formz/formz.dart';

enum NameValidationError {
  invalid
}
class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');

  const Name.dirty([super.value = '']) : super.dirty();

  static final _nameRegExp =
  RegExp(r'^(?=.*[A-Za-z])(?=.*)[A-Za-z]{3,30}$');

  @override
  NameValidationError? validator(String? value) {
    return _nameRegExp.hasMatch(value ?? '')
        ? null
        : NameValidationError.invalid;
  }
}
