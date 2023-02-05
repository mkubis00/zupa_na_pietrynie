part of 'user_credentials_cubit.dart';

class UserCredentialUpdateState extends Equatable {
  const UserCredentialUpdateState({
    this.email = const Email.pure(),
    this.name = const Name.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final Email email;
  final Name name;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props => [email, name];

  UserCredentialUpdateState copyWith({
    Email? email,
    Name? name,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return UserCredentialUpdateState(
      email: email ?? this.email,
      name: name ?? this.name,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}