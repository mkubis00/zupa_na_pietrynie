part of 'settings_options_cubit.dart';

class SettingOptionsState extends Equatable {
  const SettingOptionsState({
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
  List<Object> get props => [email, name, status];

  SettingOptionsState copyWith({
    Email? email,
    Name? name,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return SettingOptionsState(
      email: email ?? this.email,
      name: name ?? this.name,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}