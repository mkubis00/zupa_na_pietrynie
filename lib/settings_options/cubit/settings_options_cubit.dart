import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'settings_options_state.dart';

class SettingOptionsCubit extends Cubit<SettingOptionsState> {
  SettingOptionsCubit(this._authenticationRepository)
      : super(const SettingOptionsState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        emailStatus: Formz.validate([email]),
        nameStatus: Formz.validate([state.name]),
      ),
    );
  }

  void nameChanged(String value) {
    final name = Name.dirty(value);
    emit(
      state.copyWith(
        name: name,
        nameStatus: Formz.validate([name]),
        emailStatus: Formz.validate([state.email]),
      ),
    );
  }

  Future<void> updateUserName() async {
    if (!state.nameStatus.isValidated) return;
    emit(state.copyWith(
        nameStatus: FormzStatus.submissionInProgress,
        emailStatus: Formz.validate([state.email]),
    ));
    try {
      await _authenticationRepository.updateUserName(name: state.name.value);
      emit(state.copyWith(nameStatus: FormzStatus.submissionSuccess));
      emit(state.copyWith(nameStatus: FormzStatus.invalid));
    } on UpdateUserCredentialsFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          nameStatus: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(nameStatus: FormzStatus.submissionFailure));
    }
  }

  Future<void> updateUserEmail() async {
    if (!state.emailStatus.isValidated) return;
    emit(state.copyWith(
        emailStatus: FormzStatus.submissionInProgress,
        nameStatus: Formz.validate([state.name]),
    ));
    try {
      await _authenticationRepository.updateUserEmail(email: state.email.value);
      emit(state.copyWith(emailStatus: FormzStatus.submissionSuccess));
      emit(state.copyWith(emailStatus: FormzStatus.invalid));
    } on UpdateUserCredentialsFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          emailStatus: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(emailStatus: FormzStatus.submissionFailure));
    }
  }
}
