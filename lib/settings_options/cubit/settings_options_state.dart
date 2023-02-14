part of 'settings_options_cubit.dart';

enum PhotoStatus {
  defaultStatus,
  photoUpdateInProgress,
  photoUpdateFailure,
  photoUpdateSuccessed,
}

class SettingOptionsState extends Equatable {
  const SettingOptionsState({
    this.email = const Email.pure(),
    this.name = const Name.pure(),
    this.nameStatus = FormzStatus.pure,
    this.emailStatus = FormzStatus.pure,
    this.photoStatus = PhotoStatus.defaultStatus,
    this.errorMessage,
  });

  final Email email;
  final Name name;
  final FormzStatus nameStatus;
  final FormzStatus emailStatus;
  final String? errorMessage;
  final PhotoStatus photoStatus;

  @override
  List<Object> get props => [email, name, nameStatus, emailStatus, photoStatus];

  SettingOptionsState copyWith({
    Email? email,
    Name? name,
    FormzStatus? nameStatus,
    FormzStatus? emailStatus,
    PhotoStatus? photoStatus,
    String? errorMessage,
  }) {
    return SettingOptionsState(
      email: email ?? this.email,
      name: name ?? this.name,
      nameStatus: nameStatus ?? this.nameStatus,
      emailStatus: emailStatus ?? this.emailStatus,
      photoStatus: photoStatus ?? this.photoStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
