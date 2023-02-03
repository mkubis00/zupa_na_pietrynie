part of 'password_reset_cubit.dart';

class PasswordResetState extends Equatable {
  const PasswordResetState({
    this.email = const Email.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final Email email;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props => [email, status];

  PasswordResetState copyWith({
    Email? email,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return PasswordResetState(
      email: email ?? this.email,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}