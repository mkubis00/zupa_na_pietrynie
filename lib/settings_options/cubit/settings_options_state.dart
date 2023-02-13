part of 'settings_options_cubit.dart';

class SettingOptionsState extends Equatable {
  const SettingOptionsState({
    this.email = const Email.pure(),
    this.name = const Name.pure(),
    this.nameStatus = FormzStatus.pure,
    this.emailStatus = FormzStatus.pure,
    this.errorMessage,
  });

  final Email email;
  final Name name;
  final FormzStatus nameStatus;
  final FormzStatus emailStatus;
  final String? errorMessage;

  @override
  List<Object> get props => [email, name, nameStatus, emailStatus];

  SettingOptionsState copyWith({
    Email? email,
    Name? name,
    FormzStatus? nameStatus,
    FormzStatus? emailStatus,
    String? errorMessage,
  }) {
    return SettingOptionsState(
      email: email ?? this.email,
      name: name ?? this.name,
      nameStatus: nameStatus ?? this.nameStatus,
      emailStatus: emailStatus ?? this.emailStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}